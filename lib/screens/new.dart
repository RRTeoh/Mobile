import 'package:flutter/material.dart';
import 'package:asgm1/details/schedulecourse.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:asgm1/settings.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage> {
  bool isSettingsOpen = false;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: isSettingsOpen
            ? null
            : const Text(
                "Gym Schedule",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: isSettingsOpen
            ? null
            : IconButton(
                icon: const Icon(Icons.list, color: Colors.black),
                onPressed: () {
                  setState(() {
                    isSettingsOpen = true;
                  });
                },
              ),
      ),
      body: Stack(
        children: [ 
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlue.shade100, Colors.white],
              ),
            ),
          ),
        ],
      ),
   );
  }
}
