import 'package:flutter/material.dart';

class StoryRead extends StatelessWidget {
  final String imagePath;
  final String username;

  const StoryRead({
    required this.imagePath,
    required this.username,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAvatar(
      gradient: LinearGradient(
        colors: [Colors.grey, Colors.grey.shade400],
      ),
    );
  }

  Widget _buildAvatar({required Gradient gradient}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
          ),
          child: CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 37,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          username,
          style: TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class StoryNonRead extends StatelessWidget {
  final String imagePath;
  final String username;
  final bool showPlus;

  const StoryNonRead({
    required this.imagePath,
    required this.username,
    this.showPlus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.orange, Colors.yellow],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 37,
                  backgroundImage: AssetImage(imagePath),
                ),
              ),
            ),
            if (showPlus)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.add, size: 19, color: Colors.white),
                ),
              ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          username,
          style: TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

Widget storySection() {
  return Container(
    color: Colors.lightBlue[100],
    padding: EdgeInsets.symmetric(vertical: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        StoryNonRead(
          imagePath: 'assets/images/pic1.jpg',
          username: 'Jackson Wang',
          showPlus: true,
        ),
        StoryNonRead(
          imagePath: 'assets/images/pic2.jpg',
          username: 't-rex123',
        ),
        StoryRead(
          imagePath: 'assets/images/pic3.jpg',
          username: 'Ashley_520',
        ),
        StoryRead(
          imagePath: 'assets/images/pic4.jpg',
          username: 'Sina886',
        ),
      ],
    ),
  );
}
