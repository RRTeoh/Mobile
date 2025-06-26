import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int selectedStars = 0;
  final List<String> feedbackOptions = [
    "Useful workout apps",
    "Helpful reminders and alerts",
    "User-friendly design",
    "Motivating user interface",
    "Accurate workout tracking",
    "Comprehensive health features"
  ];
  final Set<String> selectedOptions = {};
  final TextEditingController _controller = TextEditingController();
  String buttonText = "Submit Feedback";

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        Icons.star,
        size: 30,
        color: selectedStars > index ? Colors.amber : Colors.grey[100],
      ),
      onPressed: () {
        setState(() {
          selectedStars = index + 1;
        });
      },
    );
  }

  Widget _buildOptionChip(String label) {
    final bool isSelected = selectedOptions.contains(label);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          if (isSelected) {
            selectedOptions.remove(label);
          } else {
            selectedOptions.add(label);
          }
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.grey),
      avatar: isSelected
          ? const Icon(Icons.check_circle, color: Color.fromARGB(255, 112, 255, 117), size: 16)
          : null,
      shape: StadiumBorder(side: BorderSide(color: const Color.fromARGB(255, 237, 237, 237))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Feedback Matters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 4),
                const Text(
                  "It takes less than 60 seconds to complete",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const Divider(height: 30),
                const Text("How Was Your Overall Experience?"),
                Row(
                  children: List.generate(5, (index) => _buildStar(index)),
                ),
                const SizedBox(height: 20),
                const Text("What did you think?"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      feedbackOptions.map((e) => _buildOptionChip(e)).toList(),
                ),
                const SizedBox(height: 20),
                const Text("What could’ve made it perfect?"),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Loved most of it! One small thing...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                // const Text(
                //   "Submit feedback for a chance to win a free hamper!",
                //   style: TextStyle(fontSize: 12, color: Colors.black54),
                // ),
                //const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff8fd4e8),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (selectedStars == 0 ||
                        selectedOptions.isEmpty ||
                        _controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please provide your feedback before submitting."),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                      setState(() {
                        buttonText = "Submitted";
                      });
                    }
                  },
                  child: Text(buttonText,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
