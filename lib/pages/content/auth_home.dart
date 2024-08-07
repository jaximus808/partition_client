import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../network/http_client.dart';
import '../../../classes/generate_token.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({super.key, required this.title});

  final String title;

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
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
