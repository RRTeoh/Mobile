import 'package:flutter/material.dart';
import 'package:asgm1/details/story.dart';
import 'package:asgm1/details/post.dart';
import 'package:asgm1/screens/chat_page.dart';
import 'package:asgm1/screens/feed_noti.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8fd4e8),
        toolbarHeight: 50,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedNoti()),
                );
              },
              child: Stack(
                children: [
                  const Icon(Icons.notifications_none, size: 25),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.red,
                      child: const Text(
                        '1',
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 40),
              child: Text(
                "Feeds",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            Row(
              children: [
                const Icon(Icons.add_box_outlined, size: 22),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 22),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.red,
                          child: const Text(
                            '2',
                            style: TextStyle(fontSize: 7, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            storySection(),
            const SizedBox(height: 5),
            Posts(
              username: 'Jackson Wang',
              userImage: 'assets/images/pic1.jpg',
              postImage: 'assets/images/post_pic1.jpg',
              caption: 'Every drop of sweat brings me closer to my goals.\nProgress takes time.',
              timeAgo: '5 minutes ago',
              initialLikes: 8,
              initialComments: [
                {"user": "t-rex123", "comment": "Keep going!", "avatar": "assets/images/pic2.jpg", "time": "10m"},
                {"user": "Ashley_520", "comment": "You inspire me!", "avatar": "assets/images/pic3.jpg", "time": "8m"},
              ],
              shares: 2,
            ),
            Posts(
              username: 'Ashley_520',
              userImage: 'assets/images/pic3.jpg',
              postImage: 'assets/images/post_pic2.jpg',
              caption: 'Fuel your body with good food and strong intentions!',
              timeAgo: '12 minutes ago',
              initialLikes: 12,
              initialComments: [
                {"user": "Sina886", "comment": "Burning!!", "avatar": "assets/images/pic4.jpg", "time": "5m"},
                {"user": "Jackson Wang", "comment": "Love it", "avatar": "assets/images/pic1.jpg", "time": "4m"},
                {"user": "Ryu_Ken", "comment": "Rock it", "avatar": "assets/images/pic6.jpg", "time": "just now"},
              ],
              shares: 1,
            ),
          ],
        ),
      ),
    );
  }
}
