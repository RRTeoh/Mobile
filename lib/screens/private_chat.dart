import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asgm1/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrivateChatPage extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserImage;

  const PrivateChatPage({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImage,
  });

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  void _markAsRead() {
    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'unreadBy': FieldValue.arrayRemove([widget.currentUserId]),
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).collection('messages').add({
        'senderId': widget.currentUserId,
        'message': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update chat meta for both sender & receiver properly
      await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).set({
        'users': [widget.currentUserId, widget.otherUserId],
        'otherUserId': widget.otherUserId,
        'otherUserName': widget.otherUserName,
        'otherUserImage': widget.otherUserImage,
        'lastMessage': text,
        'timestamp': FieldValue.serverTimestamp(),
        'unreadBy': FieldValue.arrayUnion([widget.otherUserId]),
      }, SetOptions(merge: true));

      // Send FCM push notification to the other user
      await _sendChatPushNotification(text);

      _controller.clear();
    }
  }

  Future<void> _sendChatPushNotification(String message) async {
    try {
      // Get the receiver's FCM token
      final receiverDoc = await FirebaseFirestore.instance.collection('users').doc(widget.otherUserId).get();
      if (!receiverDoc.exists) return;
      
      final receiverData = receiverDoc.data() as Map<String, dynamic>;
      final receiverFcmToken = receiverData['fcmToken'];
      
      if (receiverFcmToken != null && receiverFcmToken.isNotEmpty) {
        // Get current user's name
        final currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(widget.currentUserId).get();
        String senderName = 'Someone';
        if (currentUserDoc.exists) {
          final currentUserData = currentUserDoc.data() as Map<String, dynamic>;
          senderName = currentUserData['firstName'] ?? 'Someone';
        }

        // Send FCM push notification
        await _sendPushNotification(receiverFcmToken, senderName, message);
      }
    } catch (e) {
      print('Error sending chat push notification: $e');
    }
  }

  Future<void> _sendPushNotification(String receiverFcmToken, String senderName, String message) async {
    try {
      const String serverKey = 'YOUR_FCM_SERVER_KEY'; // Replace with your actual FCM server key
      
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': receiverFcmToken,
          'notification': {
            'title': 'New Message from $senderName 💬',
            'body': message.length > 50 ? '${message.substring(0, 50)}...' : message,
          },
          'data': {
            'senderName': senderName,
            'action': 'sent you a message',
            'type': 'chat',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Chat push notification sent successfully');
      } else {
        print('Failed to send chat push notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(Timestamp timestamp) {
    final time = timestamp.toDate();
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour.$minute$period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Row(
          children: [
            CircleAvatar(
              radius: 16, 
              backgroundImage: widget.otherUserImage.startsWith('http') 
                  ? NetworkImage(widget.otherUserImage) 
                  : AssetImage(widget.otherUserImage) as ImageProvider,
            ),
            const SizedBox(width: 8),
            Text(
              widget.otherUserName,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Error'));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == widget.currentUserId;
                    final currentTime = msg['timestamp'] as Timestamp?;
                    
                    // Check if we should show timestamp for this message
                    bool shouldShowTime = false;
                    if (currentTime != null) {
                      if (index == 0) {
                        // Always show time for first message
                        shouldShowTime = true;
                      } else {
                        // Check if previous message was more than 5 minutes ago
                        final previousMsg = messages[index - 1].data() as Map<String, dynamic>;
                        final previousTime = previousMsg['timestamp'] as Timestamp?;
                        
                        if (previousTime != null) {
                          final timeDiff = currentTime.toDate().difference(previousTime.toDate());
                          shouldShowTime = timeDiff.inMinutes >= 5;
                        }
                      }
                    }
                    
                    final time = shouldShowTime && currentTime != null ? _formatTime(currentTime) : '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (time.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ),
                        Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(msg['message'] ?? '', style: const TextStyle(fontSize: 13.5)),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 13),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 39,
                    height: 39,
                    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
