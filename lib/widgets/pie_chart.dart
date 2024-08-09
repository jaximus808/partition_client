import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({
    super.key,
    required this.totalIncome,
  });

  final double totalIncome;

  @override
  State<PieChartWidget> createState() => _PieChatWidgetState();
}

class _PieChatWidgetState extends State<PieChartWidget> {
  double want = 0.3;
  double need = 0.5;
  double invest = 0.2;

  late Map<String, double> dataMap = {
    "Needs": widget.totalIncome * need,
    "Wants": widget.totalIncome * want,
    "Investments": widget.totalIncome * invest
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 1.5,
      colorList: const <Color>[
        Color.fromRGBO(87, 122, 47, 1),
        Color.fromRGBO(119, 168, 61, 1),
        Color.fromRGBO(148, 209, 77, 1),
      ],
      initialAngleInDegree: 270,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      centerText: "Total Budget",
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.top,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    );
  }
}
