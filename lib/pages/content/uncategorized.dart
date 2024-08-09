import 'dart:async';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:partition/classes/set_transaction.dart';
import 'package:partition/pages/content/auth_home.dart';
import 'package:partition/pages/content/content_page.dart';
import '../../classes/plaid_transactions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../homepage/home.dart';

import '../../google_api/google_page.dart';
import '../../../network/http_client.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class Uncategorized extends StatefulWidget {
  const Uncategorized(
      {super.key,
      required this.jwtToken,
      required this.title,
      required this.transactionsData,
      required this.plaidCursor,
      required this.displayName});

  final String jwtToken;
  final String title;
  final PlaidTransactions transactionsData;
  final String plaidCursor;
  final String displayName;

  @override
  State<Uncategorized> createState() => _UncategorizedState();
}

class _UncategorizedState extends State<Uncategorized>
    with TickerProviderStateMixin {
  HttpClient httpClient = HttpClient();

  int uncatTranIter = 0;

  List<dynamic> uncatTrans = List.empty();

  bool loading = true;
  late AnimationController controller;
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
    setState(() {
      uncatTrans = widget.transactionsData.uncatTransactions as List<dynamic>;

      loading = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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

  void updateTransaction(String type) async {
    if (loading) return;

    loading = true;
    SetTransaction setTransaction = await httpClient.plaidUpdateTransaction(
      widget.jwtToken,
      widget.plaidCursor,
      type,
    );

    if (setTransaction.success) {
      if (uncatTranIter + 1 == uncatTrans.length) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AuthHome(
                title: "partition",
                jwtToken: widget.jwtToken,
                displayName: widget.displayName,
              ),
            ),
          );
        }
        return;
      }
      setState(() {
        uncatTranIter++;
      });
      loading = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This transaction set as $type!'),
          ),
        );
      }
    } else {
      if (setTransaction.error == -2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erm webhook done with no webhook?'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong, try again later :('),
            ),
          );
        }
        print(setTransaction.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Partition',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
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
                  Text(
                    "Before we begin, we'll need you to categorize the expense we've found.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Be honest as this only benefits your finicial future, not ours!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 40.0),
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  decoration: BoxDecoration(
                      color:
                          Color.fromRGBO(255, 255, 255, (loading) ? 0.0 : 1.0)),
                  child: (uncatTrans.isNotEmpty && !loading)
                      ? Column(
                          children: <Widget>[
                            Text(
                              "Transaction Left: $uncatTranIter/${uncatTrans.length}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Name: ${uncatTrans[uncatTranIter]["name"]}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "at ${(uncatTrans[uncatTranIter]["authorized_date"] != null) ? uncatTrans[uncatTranIter]["authorized_date"] : uncatTrans[uncatTranIter]["date"]}",
                              style: const TextStyle(fontSize: 24),
                            ),
                            Text(
                              "cost: \$${uncatTrans[uncatTranIter]["amount"]}",
                              style: const TextStyle(fontSize: 24),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () =>
                                        {updateTransaction("want")},
                                    style: ButtonStyle(
                                        padding:
                                            WidgetStateProperty.all<EdgeInsets>(
                                                const EdgeInsets.all(20)),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Colors.lightGreen),
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)))),
                                    child: const Text(
                                      'Want',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        {updateTransaction("need")},
                                    style: ButtonStyle(
                                        padding:
                                            WidgetStateProperty.all<EdgeInsets>(
                                                const EdgeInsets.all(20)),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Colors.lightGreen),
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)))),
                                    child: const Text(
                                      'Need',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => {
                                      updateTransaction("invest"),
                                    },
                                    style: ButtonStyle(
                                        padding:
                                            WidgetStateProperty.all<EdgeInsets>(
                                                const EdgeInsets.all(20)),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Colors.lightGreen),
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)))),
                                    child: const Text(
                                      'Investment',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Updating Transaction"),
                            CircularProgressIndicator(
                              value: controller.value,
                              semanticsLabel: 'Circular progress indicator',
                            ),
                          ],
                        )),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
