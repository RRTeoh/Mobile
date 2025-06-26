import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asgm1/details/storyview.dart';

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
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.pink, Colors.orange, Colors.yellow]),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: CircleAvatar(radius: 29, backgroundImage: AssetImage(imagePath)),
              ),
            ),
            if (showPlus)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add, size: 19, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text(username, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class StoryRead extends StatelessWidget {
  final String imagePath;
  final String username;
  final bool showPlus;

  const StoryRead({
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
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.grey, Colors.grey.shade400]),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: CircleAvatar(radius: 29, backgroundImage: AssetImage(imagePath)),
              ),
            ),
            if (showPlus)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add, size: 19, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text(username, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

Widget storySection({required String currentUserId}) {
  return SizedBox(
    height: 110,
    width: double.infinity,
    child: Stack(
      children: [
        Container(color: const Color(0xff8fd4e8), width: double.infinity, height: 110),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                /// Own story
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('stories').doc(currentUserId).snapshots(),
                  builder: (context, userSnapshot) {
                    String username = "Your Name";
                    String userImage = "assets/images/default.jpg";
                    bool hasUnread = true;
                    bool hasStory = false;

                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      final data = userSnapshot.data!.data() as Map<String, dynamic>;
                      username = data['username'] ?? "Your Name";
                      userImage = data['userImage'] ?? "assets/images/default.jpg";
                      hasUnread = data['hasUnread'] ?? true;
                      hasStory = true;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (hasStory) {
                          FirebaseFirestore.instance.collection('stories').doc(currentUserId).update({'hasUnread': false});
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => StoryViewScreen(userId: currentUserId)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("You have no story yet")),
                          );
                        }
                      },
                      child: hasUnread
                          ? StoryNonRead(imagePath: userImage, username: username, showPlus: true)
                          : StoryRead(imagePath: userImage, username: username, showPlus: true),
                    );
                  },
                ),
                const SizedBox(width: 15),
                /// Other users' stories
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('stories').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final docs = snapshot.data!.docs;
                    final unread = <QueryDocumentSnapshot>[];
                    final read = <QueryDocumentSnapshot>[];

                    for (var doc in docs) {
                      if (doc.id == currentUserId) continue;
                      final data = doc.data() as Map<String, dynamic>;
                      if (data['hasUnread'] == true) {
                        unread.add(doc);
                      } else {
                        read.add(doc);
                      }
                    }

                    unread.sort((a, b) {
                      final ta = (a.data() as Map<String, dynamic>)['timestamp'] ?? Timestamp.now();
                      final tb = (b.data() as Map<String, dynamic>)['timestamp'] ?? Timestamp.now();
                      return (tb as Timestamp).compareTo(ta as Timestamp);
                    });

                    read.sort((a, b) {
                      final ta = (a.data() as Map<String, dynamic>)['timestamp'] ?? Timestamp.now();
                      final tb = (b.data() as Map<String, dynamic>)['timestamp'] ?? Timestamp.now();
                      return (tb as Timestamp).compareTo(ta as Timestamp);
                    });

                    final sorted = [...unread, ...read];

                    return Row(
                      children: sorted.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final username = data['username'] ?? '';
                        final userImage = data['userImage'] ?? 'assets/images/default.jpg';
                        final hasUnread = data['hasUnread'] ?? true;

                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                FirebaseFirestore.instance.collection('stories').doc(doc.id).update({'hasUnread': false});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => StoryViewScreen(userId: doc.id)),
                                );
                              },
                              child: hasUnread
                                  ? StoryNonRead(imagePath: userImage, username: username)
                                  : StoryRead(imagePath: userImage, username: username),
                            ),
                            const SizedBox(width: 15),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}