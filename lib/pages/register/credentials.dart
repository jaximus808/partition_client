import 'dart:async';
import 'package:partition/classes/google_signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:partition/pages/homepage/home.dart';
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
  final TextEditingController nameController = TextEditingController();
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
        print("getting gameplay");
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
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account creation failed on the server :()'),
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
              Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimatio) =>
                                    const MyHomePage(title: "partition"),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(-1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      alignment: Alignment.topLeft,
                    ),
                    const Text(
                      "Sign Up with Your Email, Name, and a Password!",
                      textAlign: TextAlign.center,
                    ),
                  ])),
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
                  hintText: 'name...',
                ),
                controller: nameController,
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
