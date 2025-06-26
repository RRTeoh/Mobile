import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> with SingleTickerProviderStateMixin {
  String userEmail = "";
  bool _is2FAEnabled = false;

  // Toast animation
  OverlayEntry? _overlayEntry;
  late AnimationController _toastController;
  late Animation<double> _toastAnimation;
  static const Duration _toastDuration = Duration(milliseconds: 300);
  static const Duration _toastDisplayDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _toastController = AnimationController(
      duration: _toastDuration,
      vsync: this,
    );
    _toastAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _toastController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _toastController.dispose();
    _removeOverlay();
    super.dispose();
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
                _infoRow(
                  "Password",
                  "Reset password",
                  isButton: true,
                  onButtonPressed: _onSetPasswordPressed,
                ),
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
      {bool isButton = false, bool isSwitch = false, VoidCallback? onButtonPressed}) {
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
                onPressed: onButtonPressed ?? () {},
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

  void _onSetPasswordPressed() async {
    if (userEmail.isEmpty || userEmail == "No email found") {
      _showToast("No email associated with this account.");
      return;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Reset Password',
          style: TextStyle(
              fontSize: 22
          )
        ),
        content: Text('Do you want to send a password reset email to $userEmail?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  )
                ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (result == true) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);
        if (mounted) {
          _showToast('Password reset email sent.');
        }
      } catch (e) {
        if (mounted) {
          _showToast('Failed to send reset email:\n$e');
        }
      }
    }
  }

  // Show toast message
  void _showToast(String message) {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _toastAnimation,
        builder: (context, child) => _buildToastOverlay(message),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    _toastController.forward().then((_) {
      Future.delayed(_toastDisplayDuration, () {
        _toastController.reverse().then((_) => _removeOverlay());
      });
    });
  }

  // Build toast overlay
  Widget _buildToastOverlay(String message) {
    return Positioned(
      top: 30,
      left: 20,
      right: 20,
      child: Opacity(
        opacity: _toastAnimation.value,
        child: Transform.scale(
          scale: 0.8 + 0.2 * _toastAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(230, 82, 81, 81),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Remove overlay
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _toastController.reset();
  }
}
