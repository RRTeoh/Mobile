import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedNoti extends StatelessWidget {
  const FeedNoti({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "yourUserId";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8fd4e8),
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('receiver', isEqualTo: currentUserId)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading notifications"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications yet."));
          }

          final notifications = snapshot.data!.docs;

          for (var doc in notifications) {
            if (doc['read'] == false) {
              doc.reference.update({'read': true});
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data = notifications[index].data() as Map<String, dynamic>;

              final senderAvatar = data['senderAvatar'] ?? 'assets/images/default.jpg';
              final preview = data['preview'] ?? 'assets/images/default.jpg';
              final senderName = data['senderName'] ?? 'Unknown';
              final action = data['action'] ?? '';
              final Timestamp timeStamp = data['time'] ?? Timestamp.now();
              final DateTime time = timeStamp.toDate();
              final String formattedTime = _timeAgo(time);

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: senderAvatar.contains('http')
                      ? NetworkImage(senderAvatar)
                      : AssetImage(senderAvatar) as ImageProvider,
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: senderName,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: " $action",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                subtitle: Text(formattedTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                trailing: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: preview.contains('http')
                        ? Image.network(preview, fit: BoxFit.cover)
                        : Image.asset(preview, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays < 7) return "${diff.inDays}d ago";

    return "${time.day}/${time.month}/${time.year}";
  }
}
