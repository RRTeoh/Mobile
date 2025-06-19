import 'package:flutter/material.dart';

class FeedNoti extends StatelessWidget {
  const FeedNoti({super.key});

  @override
  Widget build(BuildContext context) {
    // Grouped notifications by day label
    final Map<String, List<Map<String, dynamic>>> groupedNotifications = {
      "Today": [
        {
          "user": "Jackson Wang",
          "avatar": "assets/images/pic1.jpg",
          "action": "liked your post.",
          "time": "2m",
          "preview": "assets/images/post_pic1.jpg"
        },
        {
          "user": "Ashley_520",
          "avatar": "assets/images/pic3.jpg",
          "action": "liked your post.",
          "time": "5m",
          "preview": "assets/images/post_pic2.jpg"
        },
        {
          "user": "t-rex123",
          "avatar": "assets/images/pic2.jpg",
          "action": "commented: Great shot!",
          "time": "10m",
          "preview": "assets/images/post_pic1.jpg"
        },
        {
          "user": "Sina886",
          "avatar": "assets/images/pic4.jpg",
          "action": "liked your post.",
          "time": "12m",
          "preview": "assets/images/post_pic2.jpg"
        },
      ],
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff8fd4e8),
        elevation: 0,
        title: const Text("Notifications", style: TextStyle(color: Colors.black, fontSize:20, fontWeight: FontWeight.bold,)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: groupedNotifications.entries.map((entry) {
          final title = entry.key;
          final items = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ...items.map((noti) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(noti["avatar"]),
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: noti["user"],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          TextSpan(
                            text: " ${noti["action"]}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text:noti["time"],
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(noti["preview"], fit: BoxFit.cover),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          );
        }).toList(),
      ),
    );
  }
}
