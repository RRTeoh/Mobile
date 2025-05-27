import 'package:flutter/material.dart';
import 'package:asgm1/details/story.dart';
import 'package:asgm1/details/post.dart';

class FeedPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        toolbarHeight: 50,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.tune, size: 25), 
                SizedBox(width: 15),
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

            Text(
              "Feeds",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),

            Row(
              children: [
                Icon(Icons.add_box_outlined, size: 23),
                SizedBox(width: 15),
                Stack(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 23),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                        child: Text(
                          '2',
                          style: TextStyle(fontSize: 8, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
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
            // Stories Section
            storySection(),

            SizedBox(height: 5),

            // Posts
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
