import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HeartbeatPage extends StatelessWidget {
  const HeartbeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB2EBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Heart Statistics',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 12.0,
              percent: 1.0,
              animation: true,
              animationDuration: 600,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("117",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 4),
                  _buildWaveform(),
                  const SizedBox(height: 4),
                  const Text("bpm", style: TextStyle(color: Colors.grey)),
                ],
              ),
              progressColor: Colors.blue,
              backgroundColor: Colors.white,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildBloodPressureCardWithImage(),
                      const SizedBox(height: 16),
                      _buildSleepStat(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // RIGHT COLUMN
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildCircularStat("Oxygen Saturation", "90%", "SpO2", 0.90),
                      const SizedBox(height: 16),
                      _buildCircularStat("Respiratory Rate", "88", "breaths/\nminute", 0.88),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    return Image.asset(
      'assets/images/.png',
      height: 24,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Text(
          "waveform",
          style: TextStyle(fontSize: 10, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildBloodPressureCardWithImage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle("Blood Pressure"),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text("80 mmHg", style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text("DIA", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Spacer(),
              Text("140 mmHg", style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text("SYS", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/blood_pressure_chart.png',
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text("chart not found", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularStat(String title, String value, String subtitle, double percent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _cardTitle(title),
          const SizedBox(height: 12),
          CircularPercentIndicator(
            radius: 40,
            lineWidth: 8.0,
            percent: percent,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            progressColor: Colors.blue,
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget _buildSleepStat() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle("Sleep"),
          const SizedBox(height: 12),
          const Text("8h 13 mins", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.82,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }

  Widget _cardTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
