import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../network/http_client.dart';
import '../../../classes/plaid_transactions.dart';
import 'package:flutter/material.dart';
import '../homepage/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import '../../widgets/bar_chart.dart';

import '../../widgets/pie_chart.dart';

import '../../google_api/google_page.dart';

import '../../classes/plaid_transactions.dart';

class ContentPage extends StatefulWidget {
  const ContentPage(
      {super.key,
      required this.title,
      required this.jwtToken,
      required this.displayName,
      required this.transactionData});

  final String title;
  final String jwtToken;
  final String displayName;
  final PlaidTransactions transactionData;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  HttpClient httpClient = HttpClient();

  late double income30Days = calculateTotalincome();
  late double spentWant = calculateSpentWant();
  late double spentNeed = calculateSpentNeed();
  late double spentInvest = calculateSpentInvest();

  double calculateSpentWant() {
    double amount = 0;
    for (int i = 0; i < widget.transactionData.wantTransaction!.length; i++) {
      amount += widget.transactionData.wantTransaction![i]["amount"];
    }
    return amount;
  }

  double calculateSpentNeed() {
    double amount = 0;
    for (int i = 0; i < widget.transactionData.needTransaction!.length; i++) {
      amount += widget.transactionData.needTransaction![i]["amount"];
    }
    print(amount);
    return amount;
  }

  double calculateSpentInvest() {
    double amount = 0;
    for (int i = 0; i < widget.transactionData.investTransaction!.length; i++) {
      amount += widget.transactionData.investTransaction![i]["amount"];
    }
    return amount;
  }

  double calculateTotalincome() {
    double income = 0;
    for (int i = 0; i < widget.transactionData.incomeTransaction!.length; i++) {
      income -= widget.transactionData.incomeTransaction![i]["amount"];
    }
    return income;
  }

  @override
  void initState() {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Welcome ${widget.displayName}!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Your Income: \$$income30Days",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  PieChartWidget(totalIncome: income30Days),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            const Text(
                              "Needs",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            BarChartWidget(
                              availableIncome: income30Days * 0.5,
                              usedIncome: spentNeed,
                              height: 80,
                              width: 30,
                              graphColor: const Color.fromRGBO(87, 122, 47, 1),
                            ),
                            Text(
                              "Budget:\n\$${(income30Days * 0.5).toStringAsFixed(2)} ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Remaining:\n\$${((income30Days * 0.5) - spentNeed).toStringAsFixed(2)} ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            const Text(
                              "Wants",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            BarChartWidget(
                              availableIncome: income30Days * 0.3,
                              usedIncome: spentWant,
                              height: 80,
                              width: 30,
                              graphColor: const Color.fromRGBO(119, 168, 61, 1),
                            ),
                            Text(
                              "Budget:\n\$${(income30Days * 0.3).toStringAsFixed(2)} ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Remaining:\n\$${((income30Days * 0.3) - spentWant).toStringAsFixed(2)} ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            const Text(
                              "Investments",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            BarChartWidget(
                              availableIncome: income30Days * 0.2,
                              usedIncome: spentInvest,
                              height: 80,
                              width: 30,
                              graphColor: const Color.fromRGBO(148, 209, 77, 1),
                            ),
                            Text(
                              "Budget:\n\$${(income30Days * 0.2).toStringAsFixed(2)} ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Remaining:\n\$${((income30Days * 0.2) - spentInvest).toStringAsFixed(2)} ",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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
                ],
              ),
            ),
          );

          // This trailing comma makes auto-formatting nicer for build methods.
        },
      ),
    );
  }
}
