// CHAT PAGE
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

  String formatTime(Timestamp timestamp) {
    DateTime msgTime = timestamp.toDate();
    Duration diff = DateTime.now().difference(msgTime);
    if (diff.inMinutes < 1) return "now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${msgTime.day}/${msgTime.month}/${msgTime.year}";
  }

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
                style: const TextStyle(fontSize: 12),
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
                  hintStyle: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('chats').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text('Error loading chats'));
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                  final chats = snapshot.data!.docs;
                  final filteredChats = chats.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final otherUserName = data['otherUserName']?.toString().toLowerCase() ?? '';
                    return otherUserName.contains(_searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) {
                      final data = filteredChats[index].data() as Map<String, dynamic>;
                      final chatId = filteredChats[index].id;
                      final otherUserId = data['otherUserId'] ?? '';
                      final otherUserName = data['otherUserName'] ?? 'Unknown';
                      final otherUserImage = data['otherUserImage'] ?? 'assets/images/default.jpg';
                      final lastMessage = data['lastMessage'] ?? '';
                      final unread = data['unread'] ?? false;
                      final time = data['timestamp'] != null ? formatTime(data['timestamp']) : '';

                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(radius: 25, backgroundImage: AssetImage(otherUserImage)),
                            title: Text(otherUserName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(lastMessage, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, fontWeight: unread ? FontWeight.bold : FontWeight.normal),
                                  ),
                                ),
                                if (unread)
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                                Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            onTap: () {
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
                          const Divider(indent: 70, endIndent: 10, height: 1, thickness: 0.6, color: Colors.grey),
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
}
