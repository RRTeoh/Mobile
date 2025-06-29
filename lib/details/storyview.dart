import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoryViewScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;

  const StoryViewScreen({
    required this.userId,
    required this.currentUserId,
    super.key,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  int currentStoryIndex = 0;
  List<QueryDocumentSnapshot> stories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('stories')
            .doc(widget.userId)
            .collection('userStories')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Debug: Print snapshot information
          print('Story snapshot hasData: ${snapshot.hasData}');
          print('Story snapshot docs length: ${snapshot.data?.docs.length ?? 0}');
          
          // If no stories in userStories subcollection, try alternative structure
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No stories found in userStories, trying alternative...');
            return _buildAlternativeStoryView();
          }

          stories = snapshot.data!.docs;
          print('Found ${stories.length} stories');
          
          if (currentStoryIndex >= stories.length) {
            currentStoryIndex = 0;
          }

          final storyData = stories[currentStoryIndex].data() as Map<String, dynamic>;
          print('Current story data: $storyData');
          
          final storyImage = _getStoryImageUrl(storyData);
          
          // Fetch current user data dynamically
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(widget.userId).get(),
            builder: (context, userSnapshot) {
              String displayName = storyData['username'] ?? 'User';
              String displayImage = storyData['userImage'] ?? 'assets/images/default.jpg';
              
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                displayName = userData['firstName'] ?? storyData['username'] ?? 'User';
                displayImage = userData['avatar'] ?? storyData['userImage'] ?? 'assets/images/default.jpg';
              }

              return _buildStoryView(storyImage, displayName, displayImage);
            },
          );
        },
      ),
    );
  }

  Widget _buildAlternativeStoryView() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('stories')
          .doc(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        print('Alternative story view - hasData: ${snapshot.hasData}');
        print('Alternative story view - exists: ${snapshot.data?.exists}');
        
        if (!snapshot.hasData || !snapshot.data!.exists) {
          print('No story document found in alternative view');
          return const Center(
            child: Text("Story not found", style: TextStyle(color: Colors.white)),
          );
        }

        final storyData = snapshot.data!.data() as Map<String, dynamic>;
        print('Alternative story data: $storyData');
        
        final storyImage = _getStoryImageUrl(storyData);
        
        // Fetch current user data dynamically
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(widget.userId).get(),
          builder: (context, userSnapshot) {
            String displayName = storyData['username'] ?? 'User';
            String displayImage = storyData['userImage'] ?? 'assets/images/default.jpg';
            
            if (userSnapshot.hasData && userSnapshot.data!.exists) {
              final userData = userSnapshot.data!.data() as Map<String, dynamic>;
              displayName = userData['firstName'] ?? storyData['username'] ?? 'User';
              displayImage = userData['avatar'] ?? storyData['userImage'] ?? 'assets/images/default.jpg';
            }

            return _buildStoryView(storyImage, displayName, displayImage);
          },
        );
      },
    );
  }

  String _getStoryImageUrl(Map<String, dynamic> storyData) {
    // Debug: Print the actual story data to see what fields are available
    print('Story data: $storyData');
    
    // Try different possible field names for the image URL
    String imageUrl = (storyData['imageUrl'] ?? 
            storyData['storyImage'] ?? 
            storyData['image'] ?? 
            storyData['url'] ?? 
            storyData['imagePath'] ??
            storyData['path'] ??
            'assets/images/default.jpg').toString();
    
    print('Found image URL: $imageUrl');
    return imageUrl;
  }

  Widget _buildStoryView(String storyImage, String storedUsername, String storedUserImage) {
    return Stack(
      children: [
        // Story Image
        Center(
          child: _buildStoryImage(storyImage),
        ),

        // Story Progress Indicators (only for multiple stories)
        if (stories.length > 1)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: List.generate(stories.length, (index) {
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index == currentStoryIndex 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              }),
            ),
          ),

        // Top Bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                if (widget.userId == widget.currentUserId)
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots(),
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

        // Navigation Gestures (only for multiple stories)
        if (stories.length > 1)
          GestureDetector(
            onTapDown: (details) {
              final screenWidth = MediaQuery.of(context).size.width;
              final tapX = details.globalPosition.dx;
              
              if (tapX < screenWidth / 2) {
                // Tap on left side - previous story
                if (currentStoryIndex > 0) {
                  setState(() {
                    currentStoryIndex--;
                  });
                }
              } else {
                // Tap on right side - next story
                if (currentStoryIndex < stories.length - 1) {
                  setState(() {
                    currentStoryIndex++;
                  });
                } else {
                  // Last story - close
                  Navigator.pop(context);
                }
              }
            },
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
      ],
    );
  }

  Widget _buildStoryImage(String imageUrl) {
    if (imageUrl.contains('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/default.jpg', fit: BoxFit.contain);
        },
      );
    } else if (imageUrl.isNotEmpty) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset('assets/images/default.jpg', fit: BoxFit.contain);
    }
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
