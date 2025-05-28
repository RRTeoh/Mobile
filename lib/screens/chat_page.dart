import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final List<Map<String, String>> chatList = [
    {'name': 't-rex123', 'message': 'Noted.', 'time': '3 minutes ago', 'image': 'assets/images/pic2.jpg','unread':'true'},
    {'name': 'Ashley_520', 'message': 'Meet u later!', 'time': '6 minutes ago', 'image': 'assets/images/pic3.jpg','unread':'true'},
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
                                  fontWeight: chat['unread'] == 'true' ? FontWeight.bold : FontWeight.normal,
                                  ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (chat['unread'] == 'true') 
                                Baseline(
                                  baseline: 0,
                                  baselineType: TextBaseline.alphabetic,
                                  child:Container(
                                    width: 6,
                                    height: 6,
                                    margin: EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
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
