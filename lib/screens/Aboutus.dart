import 'package:flutter/material.dart';

class AboutBoostify extends StatelessWidget {
  const AboutBoostify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: true, 
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Boostify",
           style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
            ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
         decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff8fd4e8), Colors.white],
          ),
        ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Grey container that includes everything
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 246, 246, 246), // white
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(2, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    // Logo inside the container
                    Center(
                      child: Image(
                        image: AssetImage('assets/images/boostifylogo.png'),
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 30),

                    // About Us Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "About us",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Boostify is a health and fitness app designed to empower users to take control of their well-being.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),

                    SizedBox(height: 30),

                    // Our Approach Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Our Approach",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "At Boostify, we believe that staying healthy should be simple, engaging, and integrated into your lifestyle. That’s why we combine intuitive digital tools with real-world fitness access. By focusing on personalized tracking and smooth gym transactions, we aim to eliminate friction and help users focus on what truly matters—progress and self-care.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )        
      )
,
      ),
    );
  }
}
