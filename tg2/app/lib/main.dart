import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tg2/views/screens/home_view.dart';
import 'package:tg2/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  // Root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TG2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartUpView(),
    );
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeView(),
          maintainState: false,
        ),
      );
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
