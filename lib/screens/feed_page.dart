import 'package:flutter/material.dart';
import 'package:asgm1/details/story.dart';
import 'package:asgm1/details/post.dart';
import 'package:asgm1/screens/chat_page.dart';
import 'package:asgm1/screens/feed_noti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "yourUserId";
    String currentUserName = "Jackson Wang"; 
    String currentUserAvatar = "assets/images/pic1.jpg"; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8fd4e8),
        toolbarHeight: 50,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('receiver', isEqualTo: currentUserId)
                  .where('read', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                int unreadCount = snapshot.data?.docs.length ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedNoti()),
                    );
                  },
                  child: Stack(
                    children: [
                      const Icon(Icons.notifications_none, size: 25),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.red,
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(fontSize: 8, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
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
                      MaterialPageRoute(builder: (context) => const ChatPage()),
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
            storySection(currentUserId: currentUserId),
            const SizedBox(height: 5),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!.docs;

                return Column(
                  children: posts.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return Posts(
                      username: data['username'] ?? '',
                      userImage: data['userImage'] ?? 'assets/images/default.jpg',
                      postImage: data['postImage'] ?? 'assets/images/default.jpg',
                      caption: data['caption'] ?? '',
                      timeAgo: _timeAgo((data['time'] as Timestamp).toDate()),
                      initialLikes: data['likes'] ?? 0,
                      currentUserId: currentUserId,
                      currentUserName: currentUserName,
                      currentUserAvatar: currentUserAvatar,
                      postId: doc.id,
                      postOwnerId: data['ownerId'] ?? '',
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
  }
}
