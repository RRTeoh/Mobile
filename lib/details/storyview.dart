import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoryViewScreen extends StatelessWidget {
  final String userId;
  final String currentUserId;

  const StoryViewScreen({
    required this.userId,
    required this.currentUserId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
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
          final storedUsername = (storyData['username'] ?? 'User').toString();
          final storedUserImage = (storyData['userImage'] ?? 'assets/images/default.jpg').toString();

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

              // Top Bar - Sync live for owner
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      if (userId == currentUserId)
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                          builder: (context, userSnapshot) {
                            final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                            final username = '${userData?['firstName'] ?? ''} ${userData?['secondName'] ?? ''}'.trim();
                            final userImage = userData?['avatar'] ?? 'assets/images/default.jpg';

                            return _buildProfile(username.isNotEmpty ? username : "User", userImage);
                          },
                        )
                      else
                        _buildProfile(storedUsername, storedUserImage),

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
      ),
    );
  }

  Widget _buildProfile(String username, String imagePath) {
    final imageProvider = imagePath.contains('http')
        ? NetworkImage(imagePath)
        : AssetImage(imagePath) as ImageProvider;

    return Row(
      children: [
        CircleAvatar(backgroundImage: imageProvider, radius: 18),
        const SizedBox(width: 8),
        Text(
          username,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
