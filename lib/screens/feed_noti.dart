import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedNoti extends StatelessWidget {
  const FeedNoti({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "yourUserId";
    print("DEBUG: Current User ID -> $currentUserId");

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
            print("DEBUG: Error fetching notifications -> ${snapshot.error}");
            return const Center(child: Text("Error loading notifications"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("DEBUG: No notifications found for this user.");
            return const Center(child: Text("No notifications yet."));
          }

          final notifications = snapshot.data!.docs;
          print("DEBUG: Notifications loaded -> ${notifications.length} found");

          // Mark all as read
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

              print("DEBUG: Notification [$index] -> Sender: $senderName, Action: $action");

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(senderAvatar),
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
                trailing: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(preview, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
