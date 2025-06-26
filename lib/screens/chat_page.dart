import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'private_chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Chats', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 36,
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, size: 19),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('chats').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final chats = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['otherUserName']?.toString().toLowerCase() ?? '';
                    return name.contains(_searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chatData = chats[index].data() as Map<String, dynamic>;
                      final chatId = chats[index].id;
                      final otherUserId = chatData['otherUserId'] ?? '';
                      final otherUserName = chatData['otherUserName'] ?? 'Unknown';
                      final otherUserImage = chatData['otherUserImage'] ?? 'assets/images/default.jpg';
                      final unreadList = chatData['unreadBy'] is List ? chatData['unreadBy'] : [];
                      final bool hasUnread = unreadList.contains(currentUserId);
                      final lastMessage = chatData['lastMessage'] ?? '';
                      final time = chatData['timestamp'] != null ? _formatTime(chatData['timestamp']) : '';

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: CircleAvatar(radius: 25, backgroundImage: AssetImage(otherUserImage)),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(otherUserName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 6),
                                Text(
                                  lastMessage,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: hasUnread  ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 40,
                              height: 30,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ),
                                  if (hasUnread)
                                    const Positioned(
                                      top: -2,
                                      right: -2,
                                      child: Icon(Icons.circle, color: Colors.red, size: 10),
                                    ),
                                ],
                              ),
                            ),
                            onTap: () {
                              FirebaseFirestore.instance.collection('chats').doc(chatId).update({'unreadBy': false});
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PrivateChatPage(
                                    chatId: chatId,
                                    currentUserId: currentUserId,
                                    otherUserId: otherUserId,
                                    otherUserName: otherUserName,
                                    otherUserImage: otherUserImage,
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(indent: 70, endIndent: 10, height: 1),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final now = DateTime.now();
    final msgTime = timestamp.toDate();
    final diff = now.difference(msgTime);

    if (diff.inMinutes < 1) return "now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    if (diff.inDays == 1) return "Yesterday";
    if (diff.inDays < 7) {
      const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      return weekdays[msgTime.weekday - 1];
    }
    return "${msgTime.day}/${msgTime.month}";
  }
}
