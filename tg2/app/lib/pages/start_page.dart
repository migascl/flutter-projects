import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StartPage extends StatefulWidget {
  const StartPage({super.key, required this.apiUri});

  final String apiUri;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // This is used to test the connection to the API during launch
  // If connection fails, an alert dialog will show and give the possibility of trying again
  Future _getConnection() async {
    late var result; // Response or error code variable

    try {
      var response = await http
          .get(Uri.parse(
              '${widget.apiUri}/')) // Get response from root endpoint of API
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
      // Navigate to main page
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
      child: CircularProgressIndicator(value: null),
    ));
  }
}
