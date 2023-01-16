import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/views/screens/match/matchlist_view.dart';

Future main() async {
  await dotenv.load();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  // Root of the application
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provider list
      // Each provider is an entity in the API and follows the hierarchy set by the database
      // Entities composed of different entities are defined as Proxy Providers so their data is refreshed
      // in every parent change notification
      providers: [
        ChangeNotifierProvider<CountryProvider>(
            create: (context) => CountryProvider()),
        ChangeNotifierProxyProvider<CountryProvider, StadiumProvider>(
            create: (context) => StadiumProvider(
                Provider.of<CountryProvider>(context, listen: false)),
            update: (context, countryProvider, stadiumProvider) {
              print("Stadium/P: Update");
              if (stadiumProvider == null) throw Exception;
              stadiumProvider
                ..countryProvider = countryProvider
                ..get();
              return stadiumProvider;
            }),
        ChangeNotifierProxyProvider<StadiumProvider, ClubProvider>(
            create: (context) => ClubProvider(
                Provider.of<StadiumProvider>(context, listen: false)),
            update: (context, stadiumProvider, clubProvider) {
              print("Club/P: Update");
              if (clubProvider == null) throw Exception;
              clubProvider
                ..stadiumProvider = stadiumProvider
                ..get();
              return clubProvider;
            }),
        ChangeNotifierProxyProvider2<StadiumProvider, ClubProvider,
                MatchProvider>(
            create: (context) => MatchProvider(
                Provider.of<StadiumProvider>(context, listen: false),
                Provider.of<ClubProvider>(context, listen: false)),
            update: (context, stadiumProvider, clubProvider, matchProvider) {
              print("Match/P: Update");
              if (matchProvider == null) throw Exception;
              matchProvider
                ..stadiumProvider = stadiumProvider
                ..clubProvider = clubProvider
                ..get();
              return matchProvider;
            }),
        ChangeNotifierProxyProvider<CountryProvider, PlayerProvider>(
            create: (context) => PlayerProvider(
                Provider.of<CountryProvider>(context, listen: false)),
            update: (context, countryProvider, playerProvider) {
              print("Player/P: Update");
              if (playerProvider == null) throw Exception;
              playerProvider
                ..countryProvider = countryProvider
                ..get();
              return playerProvider;
            }),
        ChangeNotifierProxyProvider2<PlayerProvider, ClubProvider,
                ContractProvider>(
            create: (context) => ContractProvider(
                Provider.of<PlayerProvider>(context, listen: false),
                Provider.of<ClubProvider>(context, listen: false)),
            update: (context, playerProvider, clubProvider, contractProvider) {
              print("Contract/P: Update");
              if (contractProvider == null) throw Exception;
              contractProvider
                ..playerProvider = playerProvider
                ..clubProvider = clubProvider
                ..get();
              return contractProvider;
            }),
        ChangeNotifierProxyProvider<PlayerProvider, ExamProvider>(
            create: (context) => ExamProvider(
                Provider.of<PlayerProvider>(context, listen: false)),
            update: (context, playerProvider, examProvider) {
              print("Club/P: Update");
              if (examProvider == null) throw Exception;
              examProvider
                ..playerProvider = playerProvider
                ..get();
              return examProvider;
            }),
      ],
      child: MaterialApp(
        title: 'TG2',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const StartUpView(),
      ),
    );
  }
}

// Screen to verify if app has connection to API
class StartUpView extends StatefulWidget {
  const StartUpView({super.key});

  @override
  State<StartUpView> createState() => _StartUpView();
}

class _StartUpView extends State<StartUpView> {
  // This is used to test the connection with the API during launch by fetching Country data
  // Once succeeded, user is sent to Home screen
  // If connection fails, an alert dialog will be displayed and give the possibility of trying again
  Future _attemptConnection() async {
    try {
      await Provider.of<CountryProvider>(context, listen: false).get();
      await Provider.of<StadiumProvider>(context, listen: false).get();
      await Provider.of<ClubProvider>(context, listen: false).get();
      await Provider.of<PlayerProvider>(context, listen: false).get();
      // Navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MatchListView(),
          maintainState: false,
        ),
      );
    } catch (e) {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Ocorreu um erro!'),
                content: Text(
                    'Não foi possível estabelecer conexão ao servidor.\nErro: $e.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _attemptConnection();
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ));
    }
  }

  // Attempt connection on initial state
  @override
  void initState() {
    print("StartUp/V: Initialized State!");
    _attemptConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("StartUp/V: Building...");
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
