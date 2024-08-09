import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({
    super.key,
    required this.availableIncome,
    required this.usedIncome,
    required this.height,
    required this.width,
    required this.graphColor,
  });

  final double availableIncome;
  final double usedIncome;
  final double height;
  final double width;
  final Color graphColor;
  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late double innerHeight = (widget.usedIncome / widget.availableIncome) *
      (MediaQuery.of(context).size.width / 2.4);
  @override
  void initState() {
    super.initState();
    // print((widget.usedIncome / widget.availableIncome) *
    //     (MediaQuery.of(context).size.width / 2.4));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: MediaQuery.of(context).size.width / 2.4,
          width: widget.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: Color.fromRGBO(33, 33, 33, 1),
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(18, 18, 18, 1),
                width: 4,
              ),
              right: BorderSide(
                color: Color.fromRGBO(18, 18, 18, 1),
                width: 4,
              ),
              bottom: BorderSide(
                color: Color.fromRGBO(18, 18, 18, 1),
                width: 4,
              ),
              left: BorderSide(
                color: Color.fromRGBO(18, 18, 18, 1),
                width: 4,
              ),
            ),
          ),
        ),
        Container(
          height: innerHeight,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: widget.graphColor,
          ),
        ),
      ],
    );
  }
}
