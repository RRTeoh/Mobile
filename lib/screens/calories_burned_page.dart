import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CaloriesBurnedPage extends StatelessWidget {
  const CaloriesBurnedPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0A84FF);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8FD4E8), Color(0xFFEAF6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: BackButton(color: Colors.black),
                title: const Text(
                  'Analytics',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              _sectionCard(
                title: 'Weekly Activities',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You’ve done 5 activity so far this week - up from 2 last week.',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _MiniStat(title: 'Swim', value: '2'),
                        _MiniStat(title: 'Bike', value: '2'),
                        _MiniStat(title: 'Run', value: '1'),
                        _MiniStat(title: 'Total Time', value: '7h 23m'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Last 9 Weeks',
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 10,
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 2,
                            getTitlesWidget: (value, _) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                '${value.toInt()}h',
                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'W${(value + 1).toInt()}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                        topTitles: AxisTitles(),
                        rightTitles: AxisTitles(),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: primaryBlue,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                          spots: [
                            FlSpot(0, 3),
                            FlSpot(1, 5),
                            FlSpot(2, 4),
                            FlSpot(3, 6.5),
                            FlSpot(4, 2),
                            FlSpot(5, 7),
                            FlSpot(6, 3.5),
                            FlSpot(7, 8),
                            FlSpot(8, 5.5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Calories Burned 🔥',
                child: SizedBox(
                  height: 240,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 700,
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 100,
                            getTitlesWidget: (value, _) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child, bool showArrow = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (showArrow) const Icon(Icons.chevron_right, color: Color(0xFF0A84FF)),
              ],
            ),
          if (title.isNotEmpty) const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title, value;
  const _MiniStat({required this.title, required this.value, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
