/*import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KaledalRatingChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            spreadRadius: 2.0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: true),
            bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (context, value) {
                  if (value == 0) {
                    return TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
                  } else if (value == 1) {
                    return TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
                  } else {
                    return TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
                  }
                }),
          ),
          borderData: FlBorderData(
              show: true,
              border:
                  Border.all(color: Colors.black.withOpacity(0.5), width: 1)),
          minX: 0,
          maxX: 3, // This corresponds to the months from January to April
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: _generateRandomData(),
              isCurved: true,
              colors: [mainblue],
              belowBarData: BarAreaData(show: true, colors: [
                mainblue.withOpacity(0.3)
              ]), // Area fill under the line
              dotData: FlDotData(show: false), // Hide dots for a cleaner look
            ),
          ],
        ),
      ),
    );
  }

  // Generates random data for the kickplayer AI Rating trend over 4 months
  List<FlSpot> _generateRandomData() {
    final Random random = Random();
    return [
      FlSpot(0, random.nextDouble() * 30 + 50), // January (0)
      FlSpot(1, random.nextDouble() * 30 + 50), // February (1)
      FlSpot(2, random.nextDouble() * 30 + 50), // March (2)
      FlSpot(3, random.nextDouble() * 30 + 50), // April (3)
    ];
  }
}
*/
