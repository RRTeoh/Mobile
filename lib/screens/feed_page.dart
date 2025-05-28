import 'package:flutter/material.dart';
import 'package:asgm1/details/story.dart';
import 'package:asgm1/details/post.dart';
import 'package:asgm1/screens/chat_page.dart'; 

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8fd4e8),
        toolbarHeight: 50,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //Icon(Icons.list, size: 25),
                //SizedBox(width: 15),
                Stack(
                  children: [
                    Icon(Icons.notifications_none, size: 25),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 8, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left:40),
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
                Icon(Icons.add_box_outlined, size: 22),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 22),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.red,
                          child: Text(
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
            SizedBox(height: 5),
            Posts(
              username: 'Jackson Wang',
              userImage: 'assets/images/pic1.jpg',
              postImage: 'assets/images/post_pic1.jpg',
              caption: 'Every drop of sweat brings me closer to my goals.\nProgress takes time.',
              timeAgo: '5 minutes ago',
              likes: 8,
              comments: 5,
              shares: 2,
            ),
            Posts(
              username: 'Ashley_520',
              userImage: 'assets/images/pic3.jpg',
              postImage: 'assets/images/post_pic2.jpg',
              caption: 'Fuel your body with good food and strong intentions!',
              timeAgo: '12 minutes ago',
              likes: 12,
              comments: 11,
              shares: 1,
            ),
          ],
        ),
      ),
    );
  }
}
