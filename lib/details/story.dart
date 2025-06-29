import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asgm1/details/storyview.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:asgm1/services/streak_service.dart';

class StoryNonRead extends StatelessWidget {
  final String imagePath;
  final String username;
  final bool showPlus;
  final VoidCallback? onPlusTap;

  const StoryNonRead({
    required this.imagePath, 
    required this.username, 
    this.showPlus = false, 
    this.onPlusTap,
    super.key
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
              child: CircleAvatar(radius: 30, backgroundColor: Colors.white, child: CircleAvatar(radius: 29, 
              backgroundImage: imagePath.startsWith('http')
              ? NetworkImage(imagePath)
              : AssetImage(imagePath) as ImageProvider,
              )),
            ),
            if (showPlus)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPlusTap,
                  child: CircleAvatar(radius: 10, backgroundColor: Colors.blue, child: const Icon(Icons.add, size: 19, color: Colors.white)),
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
  final VoidCallback? onPlusTap;

  const StoryRead({
    required this.imagePath, 
    required this.username, 
    this.showPlus = false, 
    this.onPlusTap,
    super.key
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
              child: CircleAvatar(radius: 30, backgroundColor: Colors.white, child: CircleAvatar(radius: 29, 
              backgroundImage: imagePath.startsWith('http')
              ? NetworkImage(imagePath)
              : AssetImage(imagePath) as ImageProvider)),
            ),
            if (showPlus)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPlusTap,
                  child: CircleAvatar(radius: 10, backgroundColor: Colors.blue, child: const Icon(Icons.add, size: 19, color: Colors.white)),
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

Future<void> _createNewStory(BuildContext context, String currentUserId, String username, String userImage) async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Fetch latest user data from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (!userDoc.exists) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data not found"), backgroundColor: Colors.red),
      );
      return;
    }

    final userData = userDoc.data() as Map<String, dynamic>;
    final currentUserName = userData['firstName'] ?? 'Unknown';
    final currentUserAvatar = userData['avatar'] ?? 'assets/images/default.jpg';

    // Pick image
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Show preview dialog
      final bool? shouldPost = await showDialog<bool>(
        context: context,
        builder: (context) => StoryPreviewDialog(
          imagePath: pickedFile.path,
          username: currentUserName,
          userImage: currentUserAvatar,
        ),
      );

      if (shouldPost == true) {
        // Always use Imgur for story owner
        String imageUrl = await _uploadToImgur(File(pickedFile.path));

        // Create or update the story document with current user data
        await FirebaseFirestore.instance.collection('stories').doc(currentUserId).set({
          'username': currentUserName,
          'userImage': currentUserAvatar,
          'hasUnread': true,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Add the story image to the user's stories collection
        await FirebaseFirestore.instance
            .collection('stories')
            .doc(currentUserId)
            .collection('userStories')
            .add({
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Increment streak after successful story post
        await StreakService.incrementStreak();

        // Close loading dialog
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Story posted successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  } catch (e) {
    // Close loading dialog if it's still open
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error posting story: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<String> _uploadToImgur(File imageFile) async {
  final imageBytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(imageBytes);

  final response = await http.post(
    Uri.parse('https://api.imgur.com/3/image'),
    headers: {'Authorization': 'Client-ID 1c7272900a8c448'}, // Using the same Client-ID as in other files
    body: {'image': base64Image},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data']['link'];
  } else {
    throw Exception('Failed to upload to Imgur: ${response.body}');
  }
}

class StoryPreviewDialog extends StatelessWidget {
  final String imagePath;
  final String username;
  final String userImage;

  const StoryPreviewDialog({
    required this.imagePath,
    required this.username,
    required this.userImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header with user info and close button
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: userImage.startsWith('http')
                        ? NetworkImage(userImage)
                        : AssetImage(userImage) as ImageProvider,
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ),
            
            // Story preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            
            // Post button
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff8fd4e8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Post Story",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                /// Own story synced with user profile
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots(),
                  builder: (context, userSnapshot) {
                    String username = "Your Name";
                    String userImage = "assets/images/default.jpg";

                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      username = userData['firstName'] ?? "Your Name";
                      userImage = userData['avatar'] ?? "assets/images/default.jpg";
                    }

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('stories').doc(currentUserId).snapshots(),
                      builder: (context, storySnapshot) {
                        bool hasUnread = true;
                        bool hasStory = false;

                        if (storySnapshot.hasData && storySnapshot.data!.exists) {
                          final storyData = storySnapshot.data!.data() as Map<String, dynamic>;
                          hasUnread = storyData['hasUnread'] ?? true;
                          hasStory = true;
                        }

                        return GestureDetector(
                          onTap: () {
                            if (hasStory) {
                              FirebaseFirestore.instance.collection('stories').doc(currentUserId).update({'hasUnread': false});
                              Navigator.push(context, MaterialPageRoute(builder: (_) => StoryViewScreen(userId: currentUserId, currentUserId: currentUserId,)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have no story yet")));
                            }
                          },
                          child: hasUnread
                              ? StoryNonRead(
                                  imagePath: userImage, 
                                  username: username, 
                                  showPlus: true,
                                  onPlusTap: () async {
                                    await _createNewStory(context, currentUserId, username, userImage);
                                  },
                                )
                              : StoryRead(
                                  imagePath: userImage, 
                                  username: username, 
                                  showPlus: true,
                                  onPlusTap: () async {
                                    await _createNewStory(context, currentUserId, username, userImage);
                                  },
                                ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 15),
                /// Other users' stories (username from stories)
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
                                Navigator.push(context, MaterialPageRoute(builder: (_) => StoryViewScreen(userId: doc.id, currentUserId: currentUserId,)));
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
