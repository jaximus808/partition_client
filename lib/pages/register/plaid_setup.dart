import 'dart:async';
import 'package:partition/pages/homepage/home.dart';
import '../../network/http_client.dart';
import '../../classes/generate_token.dart';
import '../../classes/plaid_setup.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../content/auth_home.dart';
import '../register/credentials.dart';

class PlaidPage extends StatefulWidget {
  const PlaidPage({super.key, required this.title, required this.displayName});

  final String title;
  final String displayName;

  @override
  State<PlaidPage> createState() => _PlaidPageState();
}

class _PlaidPageState extends State<PlaidPage> {
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
    print(_configuration);
    PlaidLink.open(configuration: _configuration!);
  }

  void _createLinkTokenConfiguration() async {
    //here i need to talk to my server

    try {
      const storage = FlutterSecureStorage();
      String? userToken = await storage.read(key: "jwt_token");
      if (userToken == null) {
        throw "smth went wrong";
      }
      Token token = await httpClient.getToken(userToken);
      if (!token.success) {
        throw "something went wrong";
      }
      print(token.linkToken);
      setState(() {
        _configuration = LinkTokenConfiguration(token: token.linkToken);
      });
      setState(() {
        feedback = "connected!";
      });
      connect();
    } catch (e) {
      print(e);
      setState(() {
        feedback = "could not connect to server!";
      });
    }
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

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    //print("onEvent: $name, metadata: $metadata");
  }

  void _onSuccess(LinkSuccess event) async {
    final token = event.publicToken;
    final metadata = event.metadata.description();
    //print("onSuccess: $token, metadata: $metadata");
    setState(() => _successObject = event);

    print("succes!");
    try {
      const storage = FlutterSecureStorage();
      String? userToken = await storage.read(key: "jwt_token");

      if (userToken == null) {
        print("MEOW");
        throw "error";
      }
      PlaidSetup plaidSetup = await httpClient.plaidSetup(token, userToken);

      print("MEOW");
      if (plaidSetup.success) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AuthHome(
                title: "partition",
                jwtToken: userToken,
              ),
            ),
          );
        }
      } else {
        throw "plaid didn't suceed? error: ${plaidSetup.error}";
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, try again'),
          ),
        );
      }
    }
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
              Text(
                "Welcome ${widget.displayName}! Next let's set up connecting your bank account!",
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: _createLinkTokenConfiguration,
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(20)),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.lightGreen),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)))),
                      child: const Text(
                        'Connect Your Bank',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
