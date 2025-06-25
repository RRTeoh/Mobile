import 'package:flutter/material.dart';
import 'package:asgm1/screens/add_workout_page.dart'; 

class AddCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AddCard({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 130,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
          ),
          child: const Center(
            child: Icon(Icons.add, size: 28, color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
