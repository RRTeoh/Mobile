import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  String userEmail = "";
  bool _is2FAEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "No email found";
      });
    }
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
          "Account Security",
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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              title: "Account Information",
              children: [
                _infoRow("Email address", userEmail),
                _infoRow("Wallet address", "Connect wallet", isButton: true),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "Security Settings",
              children: [
                _infoRow("Two-factor authentication", "", isSwitch: true),
                _infoRow("Password", "Set password", isButton: true),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required List<Widget> children,
    Color color = Colors.white,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {bool isButton = false, bool isSwitch = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            if (isSwitch)
              Switch(
                value: _is2FAEnabled,
                onChanged: (value) {
                  setState(() {
                    _is2FAEnabled = value;
                  });
                },
                activeColor: Colors.white,                // thumb when ON
                activeTrackColor: Colors.lightGreenAccent,     // track when ON
                inactiveThumbColor: Colors.grey.shade700, // thumb when OFF
                inactiveTrackColor: Colors.grey.shade300, // track when OFF
              )
            else if (isButton)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 185, 227, 245),
                  foregroundColor: Colors.black,
                ),
                child: Text(value),
              )
            else
              Text(
                value,
                style: const TextStyle(color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }

}
