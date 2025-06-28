import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asgm1/services/notification_service.dart';

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

      _controller.clear();
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
            CircleAvatar(radius: 16, backgroundImage: AssetImage(widget.otherUserImage)),
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
                    final time = msg['timestamp'] != null ? _formatTime(msg['timestamp']) : '';

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
