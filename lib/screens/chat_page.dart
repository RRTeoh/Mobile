import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final List<Map<String, String>> chatList = [
    {'name': 't-rex123', 'message': 'Noted.', 'time': '3 minutes ago', 'image': 'assets/images/pic2.jpg'},
    {'name': 'Ashley_520', 'message': 'Meet u later!', 'time': '6 minutes ago', 'image': 'assets/images/pic3.jpg'},
    {'name': 'Sina886', 'message': 'okay', 'time': '10 minutes ago', 'image': 'assets/images/pic4.jpg'},
    {'name': 'Anthony', 'message': 'Ciao', 'time': '15 minutes ago', 'image': 'assets/images/pic5.jpg'},
    {'name': 'Ryu_Ken', 'message': 'Miss u', 'time': '20 minutes ago', 'image': 'assets/images/pic6.jpg'},
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(chat['image']!),
                      ),
                      title: Text(
                        chat['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      subtitle: Text(
                        chat['message']!,
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        chat['time']!,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ),
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