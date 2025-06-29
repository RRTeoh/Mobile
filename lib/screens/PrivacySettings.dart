import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String _maskEmail(String email) {
    // Mask everything after the first character and before the @
    final atIdx = email.indexOf('@');
    if (atIdx <= 1) return email;
    return email[0] + '**' + email.substring(atIdx);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final maskedEmail = user != null && user.email != null ? _maskEmail(user.email!) : "No email found";
    final isVerified = user?.emailVerified ?? false;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Settings',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8FD4E8), Colors.white],
            stops: [0.0, 0.8],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: kToolbarHeight + 24),
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                "Account Information",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmailTile(maskedEmail, isVerified, user),
                    const Divider(height: 24),
                    _buildActionTile(
                      icon: Icons.lock_reset,
                      label: "Reset Password",
                      onTap: _onSetPasswordPressed,
                    ),
                    const Divider(height: 24),
                    _buildActionTile(
                      icon: Icons.logout,
                      label: "Sign Out",
                      onTap: _onSignOutPressed,
                    ),
                    const Divider(height: 24),
                    _buildActionTile(
                      icon: Icons.delete_forever,
                      label: "Delete Account",
                      onTap: _onDeleteAccountPressed,
                      iconColor: Colors.red,
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTile(String maskedEmail, bool isVerified, User? user) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        if (user == null) return;
        await user.reload();
        if (user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your email is already verified.'), backgroundColor: Colors.green),
          );
        } else {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email sent!'), backgroundColor: Colors.blue),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.email, color: isVerified ? Colors.green : Colors.red, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                maskedEmail,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            if (!isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            if (isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.black54, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 15, color: textColor ?? Colors.black),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
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

  void _onSignOutPressed() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _onDeleteAccountPressed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      // Show password input dialog for re-authentication
      final TextEditingController passwordController = TextEditingController();
      final password = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Re-authentication Required'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your password to confirm account deletion:'),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => Navigator.of(context).pop(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(passwordController.text),
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      
      if (password != null && password.isNotEmpty) {
        try {
          // Re-authenticate the user
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
          
          // Now delete the account
          await user.delete();
          
          // Also delete user data from Firestore
          try {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
          } catch (e) {
            // Firestore deletion might fail, but we still want to delete the auth account
            print('Failed to delete Firestore data: $e');
          }
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        } catch (e) {
          if (mounted) {
            String errorMessage = 'Failed to delete account';
            if (e.toString().contains('wrong-password')) {
              errorMessage = 'Incorrect password. Please try again.';
            } else if (e.toString().contains('user-mismatch')) {
              errorMessage = 'Authentication failed. Please try again.';
            } else if (e.toString().contains('requires-recent-login')) {
              errorMessage = 'Please log in again before deleting your account.';
            } else {
              errorMessage = 'Failed to delete account: $e';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
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
