import 'dart:async';
import 'package:http/http.dart' as http;
import '../../network/http_client.dart';
import '../../classes/generate_token.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

import '../register/credentials.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LinkTokenConfiguration? _configuration;
  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;
  LinkObject? _successObject;

  String feedback = "";

  final httpClient = HttpClient();

  @override
  void initState() {
    super.initState();

    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
  }

  @override
  void dispose() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
    super.dispose();
  }

  void connect() {
    PlaidLink.open(configuration: _configuration!);
  }

  void _createLinkTokenConfiguration() async {
    //here i need to talk to my server

    try {
      Token token = await httpClient.getToken();
      print(token.linkToken);
      setState(() {
        _configuration = LinkTokenConfiguration(token: token.linkToken);
      });
      setState(() {
        feedback = "connected!";
      });
    } catch (e) {
      print(e);
      setState(() {
        feedback = "could not connect to server!";
      });
    }
  }

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    print("onEvent: $name, metadata: $metadata");
  }

  void _onSuccess(LinkSuccess event) {
    final token = event.publicToken;
    final metadata = event.metadata.description();
    print("onSuccess: $token, metadata: $metadata");
    setState(() => _successObject = event);
  }

  void _onExit(LinkExit event) {
    final metadata = event.metadata.description();
    final error = event.error?.description();
    print("onExit metadata: $metadata, error: $error");
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
                  "The best time to partition your money is today!",
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: <Widget>[
                  ElevatedButton(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              Text(
                _successObject?.toJson().toString() ?? "",
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
