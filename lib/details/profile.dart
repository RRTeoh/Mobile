import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imagePath;
  final String name;
  final String streak;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    required this.name,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;

    if (imagePath.startsWith('http')) {
      avatarImage = NetworkImage(imagePath);
    } else {
      avatarImage = AssetImage(imagePath);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: avatarImage,
          ),
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                streak,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
