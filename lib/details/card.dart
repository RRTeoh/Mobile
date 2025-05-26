import 'package:flutter/material.dart';

class MembershipCard extends StatefulWidget {
  final String imagePath1;
  final String imagePath2;

  const MembershipCard({
    super.key,
    required this.imagePath1,
    required this.imagePath2,
  });

  @override
  State<MembershipCard> createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> {
  bool _isFirstImage = true;

  void _toggleImage() {
    setState(() {
      _isFirstImage = !_isFirstImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleImage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            _isFirstImage ? widget.imagePath1 : widget.imagePath2, //is true use: if false
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
