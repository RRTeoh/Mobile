import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HeartbeatPage extends StatelessWidget {
  final int bpm;
  const HeartbeatPage({super.key, required this.bpm});

  @override
  Widget build(BuildContext context) {
    final int minBpm = (bpm - 20).clamp(40, bpm);
    final int maxBpm = (bpm + 20).clamp(bpm, 180);
    final int avgBpm = bpm;

    return Scaffold(
      backgroundColor: const Color(0xFFB2EBF2), // ← cyan background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Heart Rate Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // White rounded container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 32),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$bpm bpm',
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            const Text('Current Heart Rate',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Chart container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Trend",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: SizedBox(
                              width: 720,
                              height: 260,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 200,
                                  minY: 0,
                                  barTouchData: BarTouchData(enabled: false),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
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
                                        interval: 20,
                                        getTitlesWidget: (value, _) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: Text(
                                            '${value.toInt()}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 2,
                                        getTitlesWidget: (value, _) {
                                          final hour =
                                              (6 + value.toInt() * 2) % 24;
                                          final formatted =
                                              '${hour.toString().padLeft(2, '0')}:00';
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(formatted,
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(),
                                    rightTitles: AxisTitles(),
                                  ),
                                  borderData:
                                      FlBorderData(show: false),
                                  barGroups: List.generate(
                                    12,
                                    (i) => BarChartGroupData(x: i, barRods: [
                                      BarChartRodData(
                                        toY: ((bpm +
                                                    (i * 2.3 -
                                                        i % 3 * 4.1))
                                                .clamp(60, 190))
                                            .toDouble(),
                                        color: const Color(0xFF0077B6),
                                        width: 12,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Min/Max/Avg Cards
                  Row(
                    children: [
                      _buildMetricCard('Min', '$minBpm bpm',
                          Icons.arrow_downward, Colors.green),
                      const SizedBox(width: 12),
                      _buildMetricCard('Max', '$maxBpm bpm',
                          Icons.arrow_upward, Colors.red),
                      const SizedBox(width: 12),
                      _buildMetricCard('Avg', '$avgBpm bpm',
                          Icons.show_chart, Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String label, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
