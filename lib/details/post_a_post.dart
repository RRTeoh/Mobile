import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:asgm1/services/streak_service.dart';

class PostAPost extends StatefulWidget {
  const PostAPost({super.key});

  @override
  State<PostAPost> createState() => _PostAPostState();
}

class _PostAPostState extends State<PostAPost> {
  final TextEditingController _captionController = TextEditingController();
  String? selectedImage;
  bool _isPosting = false;
  bool _isUploadingImage = false;

  final picker = ImagePicker();

  void _submitPost() async {
    String caption = _captionController.text.trim();
    if (caption.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add an image and caption")),
      );
      return;
    }

    setState(() => _isPosting = true);

    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      setState(() => _isPosting = false);
      return;
    }

    // Fetch latest user profile from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (!userDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User profile not found")),
      );
      setState(() => _isPosting = false);
      return;
    }

    final userData = userDoc.data() as Map<String, dynamic>;
    String currentUserName = userData['username'] ?? 'Unknown';
    String currentUserAvatar = userData['userImage'] ?? 'assets/images/default.jpg';

    await FirebaseFirestore.instance.collection('posts').add({
      'username': currentUserName,
      'userImage': currentUserAvatar,
      'postImage': selectedImage,
      'caption': caption,
      'time': FieldValue.serverTimestamp(),
      'likes': 0,
      'ownerId': currentUserId,
    });

    // Increment streak after successful post
    await StreakService.incrementStreak();

    setState(() => _isPosting = false);
    Navigator.pop(context);
  }

  Future<void> _pickImageAndUpload() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() => _isUploadingImage = true);

      try {
        String imageUrl = await _uploadToImgur(imageFile);
        setState(() {
          selectedImage = imageUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image upload failed: $e")),
        );
      }

      setState(() => _isUploadingImage = false);
    }
  }

  Future<String> _uploadToImgur(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('https://api.imgur.com/3/image'),
      headers: {'Authorization': 'Client-ID 1c7272900a8c448'}, // Replace with your Client-ID
      body: {'image': base64Image},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['link'];
    } else {
      throw Exception('Failed to upload: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _isUploadingImage ? null : _pickImageAndUpload,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: _isUploadingImage
                    ? const Center(child: CircularProgressIndicator())
                    : selectedImage != null
                        ? Image.network(selectedImage!, fit: BoxFit.cover)
                        : const Center(child: Text("Tap to select image")),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: "Enter caption",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPosting ? null : _submitPost,
              child: _isPosting
                  ? const SizedBox(
                      height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Post"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}
