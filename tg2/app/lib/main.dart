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
import 'package:tg2/utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tg2/views/screens/match/matchlist_view.dart';

Future main() async {
  await dotenv.load();
  runApp(Main());
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
        ChangeNotifierProvider<CountryProvider>(create: (context) => CountryProvider()),
        ChangeNotifierProxyProvider<CountryProvider, StadiumProvider>(
            create: (context) => StadiumProvider(Provider.of<CountryProvider>(context, listen: false)),
            update: (context, countryProvider, stadiumProvider) {
              if (stadiumProvider == null) throw Exception;
              stadiumProvider.update(countryProvider);
              return stadiumProvider;
            }),
        ChangeNotifierProxyProvider<StadiumProvider, ClubProvider>(
            create: (context) => ClubProvider(Provider.of<StadiumProvider>(context, listen: false)),
            update: (context, stadiumProvider, clubProvider) {
              if (clubProvider == null) throw Exception;
              clubProvider.update(stadiumProvider);
              return clubProvider;
            }),
        ChangeNotifierProxyProvider2<StadiumProvider, ClubProvider, MatchProvider>(
            create: (context) => MatchProvider(
                Provider.of<StadiumProvider>(context, listen: false), Provider.of<ClubProvider>(context, listen: false)),
            update: (context, stadiumProvider, clubProvider, matchProvider) {
              if (matchProvider == null) throw Exception;
              matchProvider.update(stadiumProvider, clubProvider);
              return matchProvider;
            }),
        ChangeNotifierProxyProvider<CountryProvider, PlayerProvider>(
            create: (context) => PlayerProvider(Provider.of<CountryProvider>(context, listen: false)),
            update: (context, countryProvider, playerProvider) {
              if (playerProvider == null) throw Exception;
              playerProvider.update(countryProvider);
              return playerProvider;
            }),
        ChangeNotifierProxyProvider2<PlayerProvider, ClubProvider, ContractProvider>(
            create: (context) => ContractProvider(
                Provider.of<PlayerProvider>(context, listen: false), Provider.of<ClubProvider>(context, listen: false)),
            update: (context, playerProvider, clubProvider, contractProvider) {
              if (contractProvider == null) throw Exception;
              contractProvider.update(playerProvider, clubProvider);
              return contractProvider;
            }),
        ChangeNotifierProxyProvider<PlayerProvider, ExamProvider>(
            create: (context) => ExamProvider(Provider.of<PlayerProvider>(context, listen: false)),
            update: (context, playerProvider, examProvider) {
              if (examProvider == null) throw Exception;
              examProvider.update(playerProvider);
              return examProvider;
            }),
      ],
      child: MaterialApp(
        title: 'TG2',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('pt', 'PT')],
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
      await Provider.of<CountryProvider>(context, listen: false).get().then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MatchListView(),
              maintainState: false,
            ),
          ));
    } catch (e) {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Ocorreu um erro!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Não foi possível estabelecer conexão ao servidor.'),
                    const SizedBox(height: 16),
                    Text('$e', style: Theme.of(context).textTheme.caption),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _attemptConnection();
                      return;
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ));
    }
  }

  @override
  void initState() {
    print("StartUp/V: Initialized State!");
    super.initState();
    // Instantiate connection attempt on initial state
    WidgetsBinding.instance.addPostFrameCallback((context) => _attemptConnection());
  }

  @override
  Widget build(BuildContext context) {
    print("StartUp/V: Building...");
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary)));
  }
}
