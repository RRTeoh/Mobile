import 'package:flutter/material.dart';
import 'package:asgm1/details/story.dart';
import 'package:asgm1/details/post.dart';
import 'package:asgm1/screens/chat_page.dart';
import 'package:asgm1/screens/feed_noti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPage extends StatelessWidget {
  final String currentUserId = "yourUserId"; // Replace with FirebaseAuth.instance.currentUser!.uid
  final String currentUserName = "Jackson Wang"; // Logged-in user's display name
  final String currentUserAvatar = "assets/images/pic1.jpg"; // Logged-in user's avatar

  FeedPage({super.key});

  Stream<int> getUnreadCount(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
  }

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
                  MaterialPageRoute(builder: (context) => FeedNoti(currentUserId: currentUserId)),
                );
              },
              child: StreamBuilder<int>(
                stream: getUnreadCount(currentUserId),
                builder: (context, snapshot) {
                  int unread = snapshot.data ?? 0;
                  return Stack(
                    children: [
                      const Icon(Icons.notifications_none, size: 25),
                      if (unread > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.red,
                            child: Text(
                              '$unread',
                              style: const TextStyle(fontSize: 8, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  );
                },
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').orderBy('time', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading posts"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final posts = snapshot.data!.docs;

            if (posts.isEmpty) {
              return const Center(child: Text("No posts yet"));
            }

            return ListView.builder(
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      storySection(),
                      const SizedBox(height: 5),
                    ],
                  );
                }

                final data = posts[index - 1].data() as Map<String, dynamic>;
                final postId = posts[index - 1].id;

                return Posts(
                  username: data['username'],
                  userImage: data['userImage'],
                  postImage: data['postImage'],
                  caption: data['caption'],
                  timeAgo: _timeAgo((data['time'] as Timestamp).toDate()),
                  initialLikes: data['likes'] ?? 0,
                  shares: data['shares'] ?? 0,
                  currentUserId: currentUserId,
                  currentUserName: currentUserName,
                  currentUserAvatar: currentUserAvatar,
                  postOwnerId: data['userId'],
                  postId: postId,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
