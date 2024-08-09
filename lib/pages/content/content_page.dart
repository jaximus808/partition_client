import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../network/http_client.dart';
import '../../../classes/plaid_transactions.dart';
import 'package:flutter/material.dart';
import '../homepage/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import '../../widgets/pie_chat.dart';

import '../../google_api/google_page.dart';

class ContentPage extends StatefulWidget {
  const ContentPage(
      {super.key,
      required this.title,
      required this.jwtToken,
      required this.displayName});

  final String title;
  final String jwtToken;
  final String displayName;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
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
    await GoogleSignInApi.logout();
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
    //print(transactionData.uncatTransactions);
    if (transactionData.success) {
      print(transactionData);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, open the app again'),
          ),
        );
      }
    }
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
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Welcome ${widget.displayName}!",
                  textAlign: TextAlign.center,
                ),
              ),
              const PieChatWidget(totalIncome: 5000),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
