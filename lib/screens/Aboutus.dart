import 'package:flutter/material.dart';

class AboutBoostify extends StatelessWidget {
  const AboutBoostify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "About Boostify",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Center(
              child: Image.asset(
                'assets/images/boostifylogo.png', // replace with your actual image path
                height: 150,
              ),
            ),
            const SizedBox(height: 30),

            // About us
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "About us",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Boostify is a health and fitness app designed to empower users to take control of their well-being",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 30),

            // Our Approach
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Our Approach",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "At Boostify, we believe that staying healthy should be simple, engaging, and integrated into your lifestyle. That’s why we combine intuitive digital tools with real-world fitness access. By focusing on personalized tracking and smooth gym transactions, we aim to eliminate friction and help users focus on what truly matters—progress and self-care.",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
