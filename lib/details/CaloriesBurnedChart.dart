import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CaloriesBurnedChart extends StatelessWidget {
  const CaloriesBurnedChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12), // 🔥 Padding added
      child: SizedBox(
        height: 240,
        child: LineChart(
          LineChartData(
            //clipToBorder: false,
            minY: 0,
            maxY: 700,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 100,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.black12,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 100,
                  getTitlesWidget: (value, _) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      '${value.toInt()} cal',
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    const labels = ['May 5', 'May 12', 'May 19', 'May 26', 'Jun 2', 'Jun 9'];
                    final index = value.toInt();
                    if (index >= 0 && index < labels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          labels[index],
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                barWidth: 3,
                spots: [
                  FlSpot(0, 400),
                  FlSpot(1, 350),
                  FlSpot(2, 500),
                  FlSpot(3, 450),
                  FlSpot(4, 620),
                  FlSpot(5, 540),
                ],
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A84FF), Color(0xFF5AC8FA)],
                ),
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: const LinearGradient(
                    colors: [Color(0x400A84FF), Color(0x205AC8FA)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
