import 'package:flutter/material.dart';
import 'private_chat.dart';

class ChatPage extends StatelessWidget {
  final List<Map<String, dynamic>> chatList = [
    {
      'name': 't-rex123',
      'message': 'Noted.',
      'time': '3 minutes ago',
      'image': 'assets/images/pic2.jpg',
      'unread': 'true',
      'messages': [
        {'text': 'Hey! I just depart now.', 'isMe': true, "time": "3.00PM"},
        {'text': 'Noted.', 'isMe': false},
      ],
    },
    {
      'name': 'Ashley_520',
      'message': 'Okay, meet u later!',
      'time': '6 minutes ago',
      'image': 'assets/images/pic3.jpg',
      'unread': 'true',
      'messages': [
        {'text': 'Meet u 5pm @ TF Mall.', 'isMe': true, "time": "2.50PM"},
        {'text': 'Okay, meet u later!', 'isMe': false},
      ],
    },
    {
      'name': 'Sina886',
      'message': 'okay',
      'time': '10 minutes ago',
      'image': 'assets/images/pic4.jpg',
      'messages': [
        {'text': 'I’m heading out now.', 'isMe': false, "time": "2.48PM"},
        {'text': 'okay', 'isMe': true},
      ],
    },
    {
      'name': 'Anthony',
      'message': 'Ciao',
      'time': '15 minutes ago',
      'image': 'assets/images/pic5.jpg',
      'messages': [
        {'text': 'Ciao', 'isMe': false, "time": "2.30PM"},
      ],
    },
    {
      'name': 'Ryu_Ken',
      'message': 'Miss u',
      'time': '20 minutes ago',
      'image': 'assets/images/pic6.jpg',
      'messages': [
        {'text': 'Miss u', 'isMe': false, "time": "2.20PM"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 36,
              child: TextField(
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, size: 19),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(fontSize: 13),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final chat = chatList[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(chat['image']!),
                        ),
                        title: Text(
                          chat['name']!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chat['message']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: chat['unread'] == 'true'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (chat['unread'] == 'true')
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Text(
                                  chat['time']!,
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PrivateChatPage(
                                name: chat['name'],
                                image: chat['image'],
                                messages: chat['messages'],
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(
                        indent: 70,
                        endIndent: 10,
                        height: 1,
                        thickness: 0.6,
                        color: Colors.grey[300],
                      ),
                    ],
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
