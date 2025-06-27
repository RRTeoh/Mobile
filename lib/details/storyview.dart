import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoryViewScreen extends StatelessWidget {
  final String userId;

  const StoryViewScreen({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('stories').doc(userId).get(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          final username = userData['username'] ?? 'User';
          final userImage = userData['userImage'] ?? 'assets/images/default.jpg';

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('stories')
                .doc(userId)
                .collection('userStories')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Story not found", style: TextStyle(color: Colors.white)),
                );
              }

              final storyData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
              final storyImage = (storyData['storyImage'] ?? 'assets/images/default.jpg').toString();

              return Stack(
                children: [
                  Center(
                    child: storyImage.contains('http')
                        ? Image.network(
                            storyImage,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/default.jpg', fit: BoxFit.contain);
                            },
                          )
                        : Image.asset(
                            storyImage.isNotEmpty ? storyImage : 'assets/images/default.jpg',
                            fit: BoxFit.contain,
                          ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: userImage.contains('http')
                                ? NetworkImage(userImage)
                                : AssetImage(userImage) as ImageProvider,
                            radius: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
