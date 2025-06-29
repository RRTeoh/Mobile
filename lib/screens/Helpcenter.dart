import 'package:flutter/material.dart';
import 'package:asgm1/screens/Notifications.dart';
import 'package:asgm1/screens/PrivacySettings.dart';
import 'package:asgm1/screens/editprofile.dart';
import 'package:asgm1/screens/Feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asgm1/services/notification_service.dart';
import 'package:audioplayers/audioplayers.dart';

class Helpcenter extends StatefulWidget {
  const Helpcenter({super.key});

  @override
  State<Helpcenter> createState() => _HelpcenterState();
}

class _HelpcenterState extends State<Helpcenter> {
  final List<bool> _faqExpanded = List.generate(10, (_) => false);
  bool _showChatBadge = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<String> questions = [
    "How to edit my profile?",
    "How to turn off notifications?",
    "How to reset my password?",
    "How to delete my account?",
    "How to update email address?",
    "How to manage payment methods?",
    "How to track my workout progress?",
    "How to contact customer support?",
    "Why am I not receiving emails?",
    "How to cancel subscription?",
  ];

final List<String> answers = [
  "To edit your profile, go to the 'Profile' page, tap the pencil/edit icon, and update fields like your name, email, or phone number. Tap 'Save' to apply changes.",

  "To turn off notifications, go to 'Settings' > 'Notifications' and toggle off the switches for the alerts you no longer want to receive.",

  "To reset your password, log out and click 'Forgot Password' on the login screen. Enter your email, and follow the link sent to your inbox to set a new password.",

  "To delete your account, go to 'Settings' > 'Manage Account' and choose 'Delete Account'. Please note this action is permanent and removes all your data.",

  "You can update your email address under 'Edit Profile'. Change the email field to a new valid address and tap 'Save'. You'll receive a verification email.",

  "Under 'Payments', you can manage saved cards or payment options. Tap 'Edit' to remove or update any method, or add a new one from the same screen.",

  "You can track your workout progress in the 'Exercise Tracker'. It logs your daily activity and shows progress charts over time.",

  "To contact our support team, go to the 'Help Center' page and tap 'Contact Us'. You can send us a message directly or email us at support@boostify.app.",

  "Make sure your email address is correct under 'Edit Profile'. Also, check your spam folder and mark Boostify emails as 'Not Spam' if found there.",

  "To cancel your subscription, go to 'Payments' > 'Subscription'. Tap on 'Cancel Subscription' and follow the instructions. You'll retain access until the end of your billing cycle.",
];

  @override
  void initState() {
    super.initState();
    // Show the red dot badge and play a notification sound when entering Help Center
    _showChatBadge = true;
    Future.delayed(Duration(milliseconds: 300), () async {
      try {
        await _audioPlayer.play(AssetSource('audios/newbubbleSFX.MP3'));
        print("sucess");
      } catch (e) {
        print("Audio failed: $e");
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Help Center",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff8fd4e8), Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildToolItem(Icons.account_circle_outlined, "Acc Check", () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                      final data = doc.data();
                      if (data != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(
                              initialFirstName: data['firstName'] ?? '',
                              initialSecondName: data['secondName'] ?? '',
                              initialEmail: data['email'] ?? user.email ?? '',
                              initialDob: data?['dob'] ?? '', 
                              initialPhone: data?['phone'] ?? '', 
                              initialAvatarUrl: data?['avatar'] ?? '',
                            ),
                          ),
                        );
                      }
                    }
                  }),
                  _buildToolItem(Icons.notifications_outlined, "Notify", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Notifications()));
                  }),
                  _buildToolItem(Icons.lock_outline, "Acc Safety", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacySettings()));
                  }),
                  _buildToolItem(Icons.feedback_outlined, "Feedback", () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 4),
                    child: Text(
                      "FAQ 💬",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ), 
                  ...List.generate(questions.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            questions[index],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(
                            _faqExpanded[index]
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                          onTap: () {
                            setState(() {
                              _faqExpanded[index] = !_faqExpanded[index];
                            });
                          },
                        ),
                        if (_faqExpanded[index])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Text(
                              answers[index],
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        const Divider(),
                      ],
                    );
                  }),                   
                ]
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _showChatBadge = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotPage()),
              );
            },
            child: Icon(Icons.support_agent, color: Colors.white),
            backgroundColor: Color(0xFF8FD4E8),
          ),
          if (_showChatBadge)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

Widget _buildToolItem(IconData icon, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.black),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    ),
  );
}
}

// Replace the placeholder ChatBotPage with a simple chatbot UI
class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final chatDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('chatbot')
            .doc('messages')
            .get();

        if (chatDoc.exists && chatDoc.data() != null) {
          final List<dynamic> messagesData = chatDoc.data()!['messages'] ?? [];
          setState(() {
            _messages.clear();
            for (var msgData in messagesData) {
              _messages.add(_ChatMessage(
                text: msgData['text'],
                isBot: msgData['isBot'],
                timestamp: msgData['timestamp'] != null 
                    ? DateTime.parse(msgData['timestamp'])
                    : DateTime.now(),
              ));
            }
          });
        } else {
          // If no chat history exists, add the initial greeting
          _addBotMessage("Hello! How can I help you today? 😊");
        }
      }
    } catch (e) {
      print("Error loading chat history: $e");
      // Add initial greeting if loading fails
      _addBotMessage("Hello! How can I help you today? 😊");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final messagesData = _messages.map((msg) => {
          'text': msg.text,
          'isBot': msg.isBot,
          'timestamp': msg.timestamp.toIso8601String(),
        }).toList();

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('chatbot')
            .doc('messages')
            .set({
          'messages': messagesData,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print("Error saving chat history: $e");
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isBot: true,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isBot: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    _addUserMessage(text);
    _controller.clear();
    
    // Generate intelligent bot response based on user input
    String botResponse = _generateBotResponse(text.toLowerCase());
    
    // Simulate bot response
    Future.delayed(Duration(milliseconds: 500), () {
      _addBotMessage(botResponse);
      _saveChatHistory(); // Save after each message exchange
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _generateBotResponse(String userMessage) {
    if (userMessage.contains('password') && (userMessage.contains('forgot') || userMessage.contains('remember') || userMessage.contains('reset'))) {
      return "You can reset your password at Privacy Settings. Go to Settings > Privacy Settings and tap on 'Reset Password' to get started! 🔐";
    }
    
    if (userMessage.contains('member') || userMessage.contains('membership') || userMessage.contains('join')) {
      return "You can visit our physical store that's nearby your location! Contact us: 019-2939-2939 📞\n\nOur team will be happy to help you with membership options and guide you through the sign-up process! 💪";
    }
    
    if (userMessage.contains('hello') || userMessage.contains('hi') || userMessage.contains('hey')) {
      return "Hello! How can I help you today? 😊\n\nI can assist you with:\n• Password reset\n• Membership information\n• General questions about Boostify";
    }
    
    if (userMessage.contains('help') || userMessage.contains('support')) {
      return "I'm here to help! What specific issue are you facing? You can ask me about:\n• Password problems\n• Membership questions\n• App features\n• Account settings";
    }
    
    if (userMessage.contains('thank') || userMessage.contains('thanks')) {
      return "Glad to help you! 😊 For specific assistance, please contact our support team: 019-2939-2939 📞";
    }
    
    // Default response for unrecognized queries
    return "I understand you're asking about '$userMessage'. For specific assistance, please contact our support team at support@boostify.app or call us at 019-2939-2939. Our team will be happy to help! 📧";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boostify Bot', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF8FD4E8),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: _isLoading 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF8FD4E8)),
                  SizedBox(height: 16),
                  Text('Loading chat history...', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: msg.isBot ? Color(0xFF8FD4E8).withOpacity(0.7) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(height: 1),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: _sendMessage,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Color(0xFF8FD4E8)),
                        onPressed: () => _sendMessage(_controller.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;
  _ChatMessage({required this.text, required this.isBot, required this.timestamp});
}
