import 'package:flutter/material.dart';
import 'package:asgm1/details/story.dart';
import 'package:asgm1/details/post.dart';
import 'package:asgm1/screens/chat_page.dart';
import 'package:asgm1/screens/feed_noti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asgm1/details/post_a_post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:asgm1/services/notification_service.dart'; 

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String currentUserId = '';
  String currentUserName = '';
  String currentUserAvatar = 'assets/images/default.jpg';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _setupFCM();
    _saveFcmToken();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    currentUserId = user.uid;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      currentUserName = data['username'] ?? 'Unknown';
      currentUserAvatar = data['userImage'] ?? 'assets/images/default.jpg';
    }

    setState(() {
      isLoading = false;
    });
  }

Future<void> sendPushNotification(String receiverFcmToken, String senderName, String actionText) async {
  const String serverKey = 'YOUR_SERVER_KEY_HERE'; // Replace with your Firebase Project Server Key

  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        'to': receiverFcmToken,
        'notification': {
          'title': senderName,
          'body': actionText,
        },
        'data': {
          'senderName': senderName,
          'action': actionText,
        },
      }),
    );
  } catch (e) {
    print('Push Notification Error: $e');
  }
}

Future<void> _sendPushNotificationToReceiver(String postOwnerId, String actionText) async {
  final ownerDoc = await FirebaseFirestore.instance.collection('users').doc(postOwnerId).get();
  if (!ownerDoc.exists) return;
  final ownerData = ownerDoc.data() as Map<String, dynamic>;
  final receiverFcmToken = ownerData['fcmToken'];

  if (receiverFcmToken != null && receiverFcmToken != "") {
    sendPushNotification(receiverFcmToken, currentUserName, actionText);
  }
}


  void _saveFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null && currentUserId.isNotEmpty) {
    await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'fcmToken': token,
    });
  }
}

Future<void> likePost(String postOwnerId, String postImageUrl) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  // Get receiver's FCM token
  final ownerDoc = await FirebaseFirestore.instance.collection('users').doc(postOwnerId).get();
  if (!ownerDoc.exists) return;
  final ownerData = ownerDoc.data() as Map<String, dynamic>;
  final receiverFcmToken = ownerData['fcmToken'];

  // Add notification to Firestore
  await FirebaseFirestore.instance.collection('notifications').add({
    'senderName': currentUserName,
    'senderAvatar': currentUserAvatar,
    'action': 'liked your post',
    'receiver': postOwnerId,
    'preview': postImageUrl,
    'time': FieldValue.serverTimestamp(),
    'read': false,
  });

  // Send FCM Push Notification to post owner
  if (receiverFcmToken != null && receiverFcmToken != "" && postOwnerId != currentUserId) {
    sendPushNotification(receiverFcmToken, currentUserName, 'liked your post');
  }
}

Future<void> commentOnPost(String postOwnerId, String postImageUrl, String commentText) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  final ownerDoc = await FirebaseFirestore.instance.collection('users').doc(postOwnerId).get();
  if (!ownerDoc.exists) return;
  final ownerData = ownerDoc.data() as Map<String, dynamic>;
  final receiverFcmToken = ownerData['fcmToken'];

  await FirebaseFirestore.instance.collection('notifications').add({
    'senderName': currentUserName,
    'senderAvatar': currentUserAvatar,
    'action': 'commented your post',
    'receiver': postOwnerId,
    'preview': postImageUrl,
    'time': FieldValue.serverTimestamp(),
    'read': false,
  });

  // Send FCM Push Notification to post owner
  if (receiverFcmToken != null && receiverFcmToken != "" && postOwnerId != currentUserId) {
    sendPushNotification(receiverFcmToken, currentUserName, 'commented your post');
  }
}

  void _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await NotificationService().initialize();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       print("DEBUG: FCM Message received");

      if (message.data.isNotEmpty) {
        String senderName = message.data['senderName'] ?? 'Someone';
        String action = message.data['action'] ?? '';

        NotificationService().sendFeedNotification(
           title: "$senderName",
           body: "$action",
        );
      }

         else if (message.notification != null) {
          // Backup for basic notification
          String title = message.notification!.title ?? "Notification";
          String body = message.notification!.body ?? "";

          NotificationService().sendFeedNotification(
            title: title,
            body: body,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8fd4e8),
        toolbarHeight: 50,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Notifications Badge
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
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedNoti()));
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),

            // Chat Badge with Unread Count
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PostAPost()));
                  },
                  child: const Icon(Icons.add_box_outlined, size: 22),
                ),
                const SizedBox(width: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('unreadBy', arrayContains: currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    int unreadChats = snapshot.data?.docs.length ?? 0;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage()));
                      },
                      child: Stack(
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 22),
                          if (unreadChats > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '$unreadChats',
                                  style: const TextStyle(fontSize: 8, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
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
                      sendPushNotificationCallback: _sendPushNotificationToReceiver,
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
