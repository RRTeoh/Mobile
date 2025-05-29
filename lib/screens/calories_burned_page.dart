import 'package:flutter/material.dart';

class CaloriesBurnedPage extends StatelessWidget {
  const CaloriesBurnedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calories Burned")),
      body: const Center(
        child: Text(
          "Detailed calories burned information will go here.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
