import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isVerificationSent = false;
  bool _isCheckingVerification = false;
  bool _isVerificationCompleted = false;
  bool _isResendCooldown = false;
  int _resendCooldownSeconds = 60;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Timer? _verificationTimer;
  Timer? _resendCooldownTimer;
  User? _tempUser;

  Future<void> _sendVerificationEmail() async {
    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Please enter your email.');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password.');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorDialog('Password must be at least 6 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create temporary user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      _tempUser = userCredential.user;

      if (_tempUser != null) {
        // Send verification email
        await _tempUser!.sendEmailVerification();
        
        // Sign out immediately to prevent automatic login
        await _auth.signOut();
        
        setState(() {
          _isVerificationSent = true;
          _isLoading = false;
          // Start resend cooldown immediately after first email sent
          _isResendCooldown = true;
          _resendCooldownSeconds = 60;
        });

        _showVerificationDialog();
        
        // Start checking for email verification
        _startVerificationCheck();
        
        // Start resend cooldown timer
        _startResendCooldown();
      }
      
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }
      _showErrorDialog(errorMessage);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showErrorDialog('An error occurred while sending verification email.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startVerificationCheck() {
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_tempUser != null) {
        try {
          // Re-sign in to check verification status
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
          
          User? currentUser = userCredential.user;
          if (currentUser != null) {
            // Reload user to get latest verification status
            await currentUser.reload();
            
            if (currentUser.emailVerified) {
              timer.cancel();
              _verificationTimer = null;
              await _completeRegistration();
            } else {
              // Sign out again to prevent automatic login
              await _auth.signOut();
            }
          }
        } catch (e) {
          // If there's an error (like user deleted), stop the timer
          timer.cancel();
          _verificationTimer = null;
          print('Error checking verification status: $e');
        }
      } else {
        // If temp user is null, stop the timer
        timer.cancel();
        _verificationTimer = null;
      }
    });
  }

  Future<void> _completeRegistration() async {
    if (_tempUser == null) return;

    setState(() {
      _isCheckingVerification = true;
    });

    try {
      // Re-sign in to create Firestore data
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      User? verifiedUser = userCredential.user;
      if (verifiedUser != null) {
        // Add user profile data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(verifiedUser.uid).set({
          'email': _emailController.text.trim(),
          'firstName': verifiedUser.uid,
          'secondName': '',
          'dob': '',
          'phone': '',
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': true,
        });

        // Sign out the user after successful account creation
        await _auth.signOut();

        setState(() {
          _isCheckingVerification = false;
          _isVerificationCompleted = true;
        });

        // Show success dialog and navigate to login page
        _showSuccessDialog('Email verified! Account created successfully. Please login to continue.');
      }
      
    } catch (e) {
      setState(() {
        _isCheckingVerification = false;
      });
      _showErrorDialog('Error creating account: $e');
    }
  }

  // Clean up unverified user if they leave the page
  Future<void> _cleanupUnverifiedUser() async {
    // Stop the verification timer first
    _verificationTimer?.cancel();
    _verificationTimer = null;
    
    // Stop the resend cooldown timer
    _resendCooldownTimer?.cancel();
    _resendCooldownTimer = null;
    
    if (_tempUser != null) {
      try {
        // Try to sign in to delete the account
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          // Delete the unverified user account
          await user.delete();
        }
        
        // Sign out after cleanup
        await _auth.signOut();
      } catch (e) {
        print('Error cleaning up unverified user: $e');
        // Try to sign out anyway
        try {
          await _auth.signOut();
        } catch (signOutError) {
          print('Error signing out: $signOutError');
        }
      }
    }
  }

  // Clean up when user actually leaves the page
  Future<void> _cleanupOnPageLeave() async {
    // Only clean up if verification is not completed
    if (!_isVerificationCompleted) {
      await _cleanupUnverifiedUser();
    }
  }

  // Resend verification email with cooldown
  Future<void> _resendVerificationEmail() async {
    if (_isResendCooldown || _tempUser == null) return;

    setState(() {
      _isResendCooldown = true;
      _resendCooldownSeconds = 60;
    });

    try {
      // Re-sign in to resend verification email
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      User? currentUser = userCredential.user;
      if (currentUser != null) {
        await currentUser.sendEmailVerification();
        
        // Sign out again to prevent automatic login
        await _auth.signOut();
        
        // Start cooldown timer only if not already running
        if (_resendCooldownTimer == null) {
          _startResendCooldown();
        }
      }
    } catch (e) {
      setState(() {
        _isResendCooldown = false;
      });
      _showErrorDialog('Failed to resend verification email. Please try again.');
    }
  }

  // Start resend cooldown timer
  void _startResendCooldown() {
    // Cancel existing timer if any
    _resendCooldownTimer?.cancel();
    
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCooldownSeconds--;
      });
      
      if (_resendCooldownSeconds <= 0) {
        timer.cancel();
        _resendCooldownTimer = null;
        setState(() {
          _isResendCooldown = false;
          _resendCooldownSeconds = 60;
        });
      }
    });
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Verification Email Sent',
          style: TextStyle(fontSize: 22),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'We have sent a verification email to:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              _emailController.text.trim(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Please check your email and click the verification link to complete your registration.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            if (_isCheckingVerification)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Verifying...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Don't stop the verification timer - let it continue checking
              // Only clean up if user actually leaves the page
              
              Navigator.of(ctx).pop();
              // Stay on signup page, don't navigate away
            },
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.justify,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Success',
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pop(context); // Jump back to the login page
            },
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  double getInitialHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 70;
    } else if (screenHeight > 750) {
      return 40;
    } else {
      return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff59a5c0),
                    Colors.white,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () async {
                                  bool canPop = await _onWillPop();
                                  if (canPop) {
                                    Navigator.pop(context);
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ),
                            
                            SizedBox(height: getInitialHeight(context)),
                            
                            Text(
                              'Create new\nAccount',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.1,
                              ),
                            ),
                            
                            SizedBox(height: 30),
                            
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'EMAIL',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 8),
                            
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  hintText: 'example@email.com',
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // PASSWORD 输入框
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'PASSWORD',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 8),
                            
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 40),
                            
                            // Show verification progress indicator instead of signup button when verification is sent
                            if (_isVerificationSent && !_isVerificationCompleted)
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Verification in Progress...',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    // Resend button with cooldown
                                    ElevatedButton(
                                      onPressed: _isResendCooldown ? null : _resendVerificationEmail,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isResendCooldown 
                                            ? Colors.grey.withOpacity(0.3) 
                                            : Colors.blue,
                                        foregroundColor: _isResendCooldown 
                                            ? Colors.grey 
                                            : Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        _isResendCooldown 
                                            ? '${_resendCooldownSeconds}s' 
                                            : 'Resend',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _sendVerificationEmail,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                            
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _verificationTimer?.cancel();
    _verificationTimer = null;
    _resendCooldownTimer?.cancel();
    _resendCooldownTimer = null;
    // Use the new cleanup logic when disposing
    _cleanupOnPageLeave();
    super.dispose();
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (_isVerificationSent && _tempUser != null && !_isVerificationCompleted) {
      // Show confirmation dialog
      bool shouldPop = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Leave Registration?',
            style: TextStyle(fontSize: 22),
          ),
          content: Text(
            'If you leave now, your unverified account will be deleted. Are you sure you want to leave?',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              child: Text(
                'Leave',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ) ?? false;
      
      if (shouldPop) {
        await _cleanupOnPageLeave();
      }
      return shouldPop;
    }
    return true;
  }
}