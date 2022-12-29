import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/utils/api/api_endpoints.dart';
import 'package:tg2/utils/api/api_service.dart';
import 'package:tg2/views/screens/home_view.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  // Root of the application
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CountryProvider>(create: (context) => CountryProvider()),
        ChangeNotifierProvider<StadiumProvider>(create: (context) => StadiumProvider()),
        ChangeNotifierProvider<ClubProvider>(create: (context) => ClubProvider()),
      ],
      child: MaterialApp(
        title: 'TG2',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StartUpView(),
      ),
      );
  }
}

// Screen to verify if app has connection to API
class StartUpView extends StatefulWidget {

  @override
  State<StartUpView> createState() => _StartUpView();
}

class _StartUpView extends State<StartUpView> {
  // This is used to test the connection to the API during launch before navigating to Home Screen
  // If connection fails, an alert dialog will show and give the possibility of trying again
  Future _attemptConnection() async {
    try{
      await ApiService().get(ApiEndpoints.root);
      // Navigate to Home screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeView(),
          maintainState: false,
        ),
      );
    } catch (e) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Ocorreu um erro!'),
            content: Text(
                'Não foi possível estabelecer conexão ao servidor.\nErro $e.'),
            actions: <Widget>[
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
