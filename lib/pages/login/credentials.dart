import 'dart:async';
import 'package:partition/classes/google_signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:partition/pages/content/auth_home.dart';
import 'package:partition/pages/homepage/home.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../register/plaid_setup.dart';

import '../../network/http_client.dart';
import '../../classes/google_signin.dart';
import '../../google_api/google_page.dart';

class LoginAuth extends StatefulWidget {
  const LoginAuth({super.key, required this.title});

  final String title;

  @override
  State<LoginAuth> createState() => _LoginAuth();
}

class _LoginAuth extends State<LoginAuth> {
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
            content: Text('Sign In Successful! Logging In...'),
          ),
        );
        GoogleSignIn signinRes = await httpClient.signUserGoogle(
          user.email,
          user.id,
          user.displayName,
        );
        if (signinRes.success) {
          const storage = FlutterSecureStorage();
          await storage.write(key: "jwt_token", value: signinRes.jwt);

          if (mounted) {
            if (signinRes.error == 3) {
              String displayName = user.displayName as String;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      PlaidPage(title: "partition", displayName: displayName),
                ),
              );
            } else if (signinRes.page != null) {
              switch (signinRes.page) {
                case 1:
                  String displayName = user.displayName as String;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => PlaidPage(
                          title: "partition", displayName: displayName),
                    ),
                  );
                  break;
                case 2:
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => AuthHome(
                        title: "partition",
                        jwtToken: signinRes.jwt,
                        displayName: user.displayName!,
                      ),
                    ),
                  );
              }
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something Went Wrong During Sign In :()'),
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
                      "Sign In with Your Email and Password!",
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
                label: const Text('Sign in with Google'),
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
