import 'dart:async';
import 'package:partition/classes/google_signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../network/http_client.dart';
import '../../classes/generate_token.dart';
import '../../google_api/google_page.dart';
import './plaid_setup.dart';

class StartAuth extends StatefulWidget {
  const StartAuth({super.key, required this.title});

  final String title;

  @override
  State<StartAuth> createState() => _StartAuth();
}

class _StartAuth extends State<StartAuth> {
  final httpClient = HttpClient();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (mounted) {
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign in Failed :('),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign In Successful! Creating Account...'),
          ),
        );
        GoogleSignUp signupRes = await httpClient.createUserGoogle(
          user.email,
          user.id,
          user.displayName,
        );
        if (signupRes.success) {
          const storage = FlutterSecureStorage();
          await storage.write(key: "jwt_token", value: signupRes.jwt);
          if (mounted) {
            String displayName = user.displayName as String;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    PlaidPage(title: "partition", displayName: displayName),
              ),
            );
          }
        }
      }

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => LoggedInPage(user: user),
      //   ),
      // );
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
                "Sign in with Your Email and a Password!",
                textAlign: TextAlign.center,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'email...',
                ),
                controller: emailController,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'password...',
                ),
                controller: passwordController,
                obscureText: true,
              ),
              const Text(
                "or sign up with google!",
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(250, 50),
                ),
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                ),
                label: Text('Sign in with Google'),
                onPressed: signIn,
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
