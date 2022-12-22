import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tg2/controller/season_controller.dart';
import 'package:tg2/views/screens/home_view.dart';
import 'package:tg2/utils/constants.dart';
import 'package:provider/provider.dart';
import 'controller/league_controller.dart';

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
          ChangeNotifierProvider(create: (context) => LeagueController()),
          ChangeNotifierProxyProvider<LeagueController, SeasonController>(
            // first, create the _proxy_ object, the one that you'll use in your UI
            // at this point, you will have access to the previously provided objects
            create: (context) => SeasonController(
                Provider.of<LeagueController>(context, listen: false)),
            // next, define a function to be called on `update`. It will return the same type
            // as the create method.
            update: (context, leagueController, seasonController) {
              print("Season Provider update");
              if (seasonController == null)
                throw ArgumentError.notNull('season');
              seasonController.leagueController = leagueController;
              return seasonController;
            },
          ),
        ],
        child: MaterialApp(
          title: 'TG2',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StartUpView(),
        ));
  }
}

// Screen to verify if app has connection to API
class StartUpView extends StatefulWidget {
  @override
  State<StartUpView> createState() => _StartUpView();
}

class _StartUpView extends State<StartUpView> {
  // This is used to test the connection to the API during launch
  // If connection fails, an alert dialog will show and give the possibility of trying again
  Future _getConnection() async {
    late var result; // Response or error code variable

    try {
      var response = await http
          .get(
              Uri.parse('${apiUrl}/')) // Get response from root endpoint of API
          .timeout(const Duration(
              seconds:
                  5)); // Throw Timeout Exception if takes longer than 5 seconds
      result = response.statusCode;
    } on TimeoutException {
      result = TimeoutException;
    } catch (e) {
      result = e;
    }

    // If response is successful (code 200) navigate to Home page, show error dialog if not
    if (result == 200) {
    } else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Ocorreu um erro!'),
                content: Text(
                    'Não foi possível estabelecer conexão ao servidor.\nErro $result.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _getConnection();
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
    super.initState();
    _getConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
