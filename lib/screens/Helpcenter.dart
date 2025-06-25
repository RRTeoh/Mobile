import 'package:flutter/material.dart';

class Helpcenter extends StatefulWidget {
  const Helpcenter({super.key});

  @override
  State<Helpcenter> createState() => _HelpcenterState();
}

class _HelpcenterState extends State<Helpcenter> {
  final List<bool> _faqExpanded = List.generate(10, (_) => false);

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
                  _buildToolItem(Icons.account_circle, "Acc Check"),
                  _buildToolItem(Icons.notifications, "Notify"),
                  _buildToolItem(Icons.lock_outline, "Acc Safety"),
                  _buildToolItem(Icons.card_giftcard, "Vouchers"),
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
    );
  }

Widget _buildToolItem(IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 30, color: Colors.black),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
}
