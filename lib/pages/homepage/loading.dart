import 'dart:async';
import 'package:partition/classes/token_check.dart';
import 'package:partition/pages/register/plaid_setup.dart';

import '../../network/http_client.dart';
import 'package:flutter/material.dart';
import './home.dart';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../content/auth_home.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key, required this.title});

  final String title;

  @override
  State<LoadingPage> createState() => _MyLoadingPage();
}

class _MyLoadingPage extends State<LoadingPage> with TickerProviderStateMixin {
  late AnimationController controller;

  HttpClient httpClient = HttpClient();

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    checkDevice();
    super.initState();
  }

  //write comments here
  Future<void> checkDevice() async {
    const storage = FlutterSecureStorage();
    String? potToken = await storage.read(key: "jwt_token");
    print(potToken);
    if (mounted) {
      if (potToken == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const MyHomePage(title: "partition")),
        );
      } else {
        TokenCheck userData = await httpClient.checkToken(potToken);
        if (!userData.success) {
          await storage.delete(key: "jwt_token");
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: "partition")),
            );
          }
        } else {
          if (mounted) {
            print(userData.loginStatus);
            if (userData.loginStatus == 1) {
              String displayName = userData.username;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      PlaidPage(title: "partition", displayName: displayName),
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => AuthHome(
                          title: "partition",
                          jwtToken: potToken,
                          displayName: userData.username,
                        )),
              );
            }
          }
        }
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                'Loading',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              CircularProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Circular progress indicator',
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
