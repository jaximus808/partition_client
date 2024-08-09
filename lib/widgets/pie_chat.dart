import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChatWidget extends StatefulWidget {
  const PieChatWidget({
    super.key,
    required this.totalIncome,
  });

  final double totalIncome;

  @override
  State<PieChatWidget> createState() => _PieChatWidgetState();
}

class _PieChatWidgetState extends State<PieChatWidget> {
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
        Color.fromRGBO(255, 0, 0, 1),
        Color.fromRGBO(0, 255, 0, 1),
        Color.fromRGBO(0, 0, 255, 1),
      ],
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      centerText: "Total Budget",
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
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
