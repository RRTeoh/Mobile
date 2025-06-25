import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StepsDetailPage extends StatelessWidget {
  const StepsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2EBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Steps Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard(
              icon: Icons.directions_walk,
              label: "Today's Steps",
              value: "6,240 / 10,000",
              progress: 0.624,
            ),
            const SizedBox(height: 12),
            _buildStatCard(icon: Icons.access_time, label: "Active Time", value: "45 mins"),
            const SizedBox(height: 12),
            _buildStatCard(icon: Icons.map, label: "Distance Walked", value: "4.1 km"),
            const SizedBox(height: 12),
            _buildStatCard(icon: Icons.local_fire_department, label: "Calories Burned", value: "210 kcal"),
            const SizedBox(height: 24),
            const Text(
              "Weekly Progress",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildWeeklyChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(icon, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blue,
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 12000,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${(value / 1000).toStringAsFixed(0)}K',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, _) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(days[value.toInt()], style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true, horizontalInterval: 2000),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              barWidth: 3,
              color: Colors.blue.shade600,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade200.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              spots: const [
                FlSpot(0, 8000),
                FlSpot(1, 7200),
                FlSpot(2, 5600),
                FlSpot(3, 9200),
                FlSpot(4, 10400),
                FlSpot(5, 6400),
                FlSpot(6, 7000),
              ],
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
