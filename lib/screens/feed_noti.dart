import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedNoti extends StatefulWidget {
  final String currentUserId;

  const FeedNoti({super.key, required this.currentUserId});

  @override
  State<FeedNoti> createState() => _FeedNotiState();
}

class _FeedNotiState extends State<FeedNoti> {
  late CollectionReference<Map<String, dynamic>> notificationsRef;

  @override
  void initState() {
    super.initState();
    notificationsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .collection('notifications');

    _markAllAsRead();
  }

  Future<void> _markAllAsRead() async {
    final unreadSnap = await notificationsRef.where('read', isEqualTo: false).get();
    for (var doc in unreadSnap.docs) {
      doc.reference.update({'read': true});
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
  }

  ImageProvider _getImage(String path) {
    if (path.startsWith("http")) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: notificationsRef.orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading notifications"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final noti = notifications[index].data();
              final timestamp = noti['time'] as Timestamp;
              final isRead = noti['read'] ?? false;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                tileColor: isRead ? null : Colors.blue.shade50,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: _getImage(noti['avatar']),
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: noti['user'],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: " ${noti['action']}",
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: " ${_timeAgo(timestamp.toDate())}",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                trailing: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: _getImage(noti['preview']),
                      fit: BoxFit.cover,
                    ),
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
