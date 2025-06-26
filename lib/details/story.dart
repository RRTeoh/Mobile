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

  const StoryRead({
    required this.imagePath,
    required this.username,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 5),
        Text(username, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

Widget storySection({
  required String currentUserId,
}) {
  return SizedBox(
    height: 110,
    width: double.infinity,
    child: Stack(
      children: [
        Container(
          color: const Color(0xff8fd4e8),
          width: double.infinity,
          height: 110,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),

                // Current user's story (detect by hasStory flag)
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserId)
                      .collection('stories')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? [];
                    final hasStory = docs.isNotEmpty;

                    String username = "Your Name";
                    String userImage = "assets/images/default.jpg";

                    if (docs.isNotEmpty) {
                      final data = docs.first.data() as Map<String, dynamic>;
                      username = data['username'] ?? "Your Name";
                      userImage = data['userImage'] ?? "assets/images/default.jpg";
                    }

                    return GestureDetector(
                      onTap: () {
                        if (hasStory) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryViewScreen(userId: currentUserId),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("You have no story yet")),
                          );
                        }
                      },
                      child: StoryNonRead(
                        imagePath: userImage,
                        username: username,
                        showPlus: !hasStory,
                      ),
                    );
                  },
                ),

                const SizedBox(width: 15),

                // Other users' stories
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('stories')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();

                    final stories = snapshot.data!.docs;

                    final unreadStories = stories.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final parentUserId = doc.reference.parent.parent?.id ?? '';
                      return data['hasUnread'] == true && parentUserId != currentUserId;
                    }).toList();

                    final readStories = stories.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final parentUserId = doc.reference.parent.parent?.id ?? '';
                      return (data['hasUnread'] != true) && parentUserId != currentUserId;
                    }).toList();

                    return Row(
                      children: [
                        ...unreadStories.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final parentUserId = doc.reference.parent.parent?.id ?? '';

                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoryViewScreen(userId: parentUserId),
                                    ),
                                  );
                                },
                                child: StoryNonRead(
                                  imagePath: data['userImage'] ?? 'assets/images/default.jpg',
                                  username: data['username'] ?? '',
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                          );
                        }),

                        ...readStories.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final parentUserId = doc.reference.parent.parent?.id ?? '';

                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoryViewScreen(userId: parentUserId),
                                    ),
                                  );
                                },
                                child: StoryRead(
                                  imagePath: data['userImage'] ?? 'assets/images/default.jpg',
                                  username: data['username'] ?? '',
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                          );
                        }),
                      ],
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
