import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'private_chat.dart';
import 'package:asgm1/services/notification_service.dart';

class SearchUsersPage extends StatelessWidget {
  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('More suggestions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            final users = snapshot.data!.docs.where((doc) => doc.id != currentUserId).toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final userId = users[index].id;
                final username = userData['firstName'] ?? 'Unknown';
                final avatar = userData['avatar'] ?? 'assets/images/default.jpg';

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: CircleAvatar(radius: 25, backgroundImage: avatar.startsWith('http') ? NetworkImage(avatar) : AssetImage(avatar) as ImageProvider),
                      ),
                      title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      onTap: () async {
                        String chatId = _generateChatId(currentUserId, userId);

                        final chatDoc = await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
                        if (!chatDoc.exists) {
                          await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
                            'users': [currentUserId, userId],
                            'otherUserId': userId,
                            'otherUserName': username,
                            'otherUserImage': avatar,
                            'unreadBy': [],
                          });
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrivateChatPage(
                              chatId: chatId,
                              currentUserId: currentUserId,
                              otherUserId: userId,
                              otherUserName: username,
                              otherUserImage: avatar,
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
    );
  }

  String _generateChatId(String user1, String user2) {
    return (user1.hashCode <= user2.hashCode)
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }
}
