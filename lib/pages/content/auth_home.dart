import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../network/http_client.dart';
import '../../../classes/plaid_transactions.dart';
import 'package:flutter/material.dart';
import '../homepage/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({super.key, required this.title, required this.jwtToken});

  final String title;
  final String jwtToken;

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  HttpClient httpClient = HttpClient();

  @override
  void initState() {
    getFinData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void signOut() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: "jwt_token");
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "partition"),
        ),
      );
    }
  }

  Future<void> getFinData() async {
    String jwtToken = widget.jwtToken;
    PlaidTransactions transactionData =
        await httpClient.plaidTransactions(jwtToken);
    print(transactionData.uncatTransactions);
    // if (transaction_data.success) {
    //   print(transaction_data);
    // }
    // else{

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                'Partition',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  "Welcome ur logged in!",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: signOut,
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(12)),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.lightGreen),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)))),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // ElevatedButton(
              //     onPressed: _createLinkTokenConfiguration,
              //     style: ButtonStyle(
              //         padding: WidgetStateProperty.all<EdgeInsets>(
              //             const EdgeInsets.all(20)),
              //         backgroundColor:
              //             WidgetStateProperty.all(Colors.lightGreen),
              //         shape: WidgetStateProperty.all(RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12)))),
              //     child: const Text(
              //       'Get Started!',
              //       style: TextStyle(
              //           fontSize: 20, fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.center,
              //     )),

              // ElevatedButton(
              //   onPressed: _configuration != null ? () => connect() : null,
              //   child: Text("Open"),
              // ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
