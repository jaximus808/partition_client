import 'dart:async';
import 'package:http/http.dart' as http;
import '../../network/http_client.dart';
import '../../classes/generate_token.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import '../register/credentials.dart';
import '../login/credentials.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String feedback = "";

  final httpClient = HttpClient();

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
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  "The best time to partition your money is today!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginAuth(title: "partition")),
                      )
                    },
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(20)),
                        backgroundColor:
                            WidgetStateProperty.all(Colors.lightGreen),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)))),
                    child: const Text(
                      'Sign In',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const StartAuth(title: "partition")),
                        )
                      },
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(20)),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.lightGreen),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)))),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                  Container(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(feedback),
                  )
                ],
              ),
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
