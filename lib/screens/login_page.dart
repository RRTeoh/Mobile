import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:asgm1/screens/forgotpassword_page.dart';
import 'package:asgm1/screens/signup_page.dart';

// User Credentials Model
class SavedAccount {
  final String email;
  final String password;
  

  SavedAccount({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };

  factory SavedAccount.fromJson(Map<String, dynamic> json) => SavedAccount(
    email: json['email'],
    password: json['password'],
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _showAccountDropdown = false;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FocusNode _emailFocusNode = FocusNode();
  
  List<SavedAccount> _savedAccounts = [];
  
  late AnimationController _dropdownAnimationController;
  late Animation<double> _dropdownAnimation;
  
  // SharedPreferences Key-Value
  static const String _keySavedAccounts = 'saved_accounts';
  static const String _keyLastRememberMe = 'last_remember_me';
  static const String _keyLastLoggedInEmail = 'last_logged_in_email';
  static const String _keyShouldClearFields = 'should_clear_fields';

  

  @override
  void initState() {
    super.initState();
    _loadSavedAccounts();
    _emailFocusNode.addListener(_onEmailFocusChange);
    
    // Initialising the dropdown animation controller
    _dropdownAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _dropdownAnimation = CurvedAnimation(
      parent: _dropdownAnimationController,
      curve: Curves.easeInOut,
    );
  }

  void _onEmailFocusChange() {
    if (!_emailFocusNode.hasFocus) {
      _hideDropdown();
    }
  }

  double _calculateDropdownHeight() {
    if (_savedAccounts.isEmpty) {
      return 0.0;
    } else if (_savedAccounts.length == 1) {
      return 55.0;
    } else {
      return 100.0;
    }
  }

  // Loading a list of saved accounts
  Future<void> _loadSavedAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountsJson = prefs.getStringList(_keySavedAccounts) ?? [];
      final lastRememberMe = prefs.getBool(_keyLastRememberMe) ?? false;
      final shouldClearFields = prefs.getBool(_keyShouldClearFields) ?? false;
      
      setState(() {
        _savedAccounts = accountsJson
            .map((jsonStr) => SavedAccount.fromJson(json.decode(jsonStr)))
            .toList();
        _rememberMe = lastRememberMe;
      });

      // Check if fields need to be cleared
      if (shouldClearFields) {
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          _rememberMe = false;
        });
        
        await prefs.setBool(_keyShouldClearFields, false);
        await prefs.remove(_keyLastLoggedInEmail);
      } else {
        // If there are saved accounts and no fields need to be cleared, auto-populate the last account used
        if (_savedAccounts.isNotEmpty) {
          final lastAccount = _savedAccounts.first;
          _emailController.text = lastAccount.email;
          _passwordController.text = lastAccount.password;
        }
      }
    } catch (e) {
      print('Error loading saved accounts: $e');
    }
  }

  // Save account to list
  Future<void> _saveAccount(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_keyLastLoggedInEmail, email);
      await prefs.setBool(_keyLastRememberMe, _rememberMe);
      
      if (!_rememberMe) {
        await prefs.setBool(_keyShouldClearFields, true);
        return;
      }

      final existingIndex = _savedAccounts.indexWhere((account) => account.email == email);
      
      if (existingIndex != -1) {
        _savedAccounts[existingIndex] = SavedAccount(email: email, password: password);
      } else {
        _savedAccounts.insert(0, SavedAccount(email: email, password: password));
      }

      if (_savedAccounts.length > 5) {
        _savedAccounts = _savedAccounts.take(5).toList();
      }

      if (existingIndex != -1 && existingIndex != 0) {
        final currentAccount = _savedAccounts.removeAt(existingIndex);
        _savedAccounts.insert(0, currentAccount);
      }

      final accountsJson = _savedAccounts
          .map((account) => json.encode(account.toJson()))
          .toList();
      
      await prefs.setStringList(_keySavedAccounts, accountsJson);
      
    } catch (e) {
      print('Error saving account: $e');
    }
  }

  static Future<void> handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRememberMe = prefs.getBool(_keyLastRememberMe) ?? false;
      
      if (!lastRememberMe) {
        await prefs.setBool(_keyShouldClearFields, true);
      }
      
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  Future<void> _removeAccount(String email) async {
    try {
      setState(() {
        _savedAccounts.removeWhere((account) => account.email == email);
      });

      final prefs = await SharedPreferences.getInstance();
      final accountsJson = _savedAccounts
          .map((account) => json.encode(account.toJson()))
          .toList();
      
      await prefs.setStringList(_keySavedAccounts, accountsJson);
      
      if (_savedAccounts.isEmpty) {
        _hideDropdown();
      }
    } catch (e) {
      print('Error removing account: $e');
    }
  }

  void _selectAccount(SavedAccount account) {
    setState(() {
      _emailController.text = account.email;
      _passwordController.text = account.password;
      _rememberMe = true;
    });
    _hideDropdown();
    FocusScope.of(context).unfocus();
  }

  void _showDropdown() {
    if (_savedAccounts.isEmpty) return;
    
    setState(() {
      _showAccountDropdown = true;
    });
    
    _dropdownAnimationController.forward();
  }

  void _hideDropdown() {
    _dropdownAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showAccountDropdown = false;
        });
      }
    });
  }

  void _toggleDropdown() {
    if (_savedAccounts.isEmpty) return;
    
    if (_showAccountDropdown) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  Future<void> _signIn() async {
    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Please enter your email.');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      await _saveAccount(_emailController.text.trim(), _passwordController.text);
      
      print('Successfully login: ${userCredential.user?.email}');
      
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'INVALID_LOGIN_CREDENTIALS':
        case 'invalid-credential':
          errorMessage = 'Invalid email or password. Please check and try again.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email. Please sign up first.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled. Please contact support.';
          break;
        default:
          errorMessage = 'Failed to log in.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('An error occurred while login!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToForgotPassword() {
    _hideDropdown();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  void _navigateToSignUp() {
    _hideDropdown();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  double getInitialHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 110;
    } else if (screenHeight > 750) {
      return 80;
    } else {
      return 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _hideDropdown();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
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
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: getInitialHeight(context)),

                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            
                            SizedBox(height: 14),
                            
                            Text(
                              'Sign in to continue.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
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
                            
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
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
                                      suffixIcon: _savedAccounts.isNotEmpty
                                          ? GestureDetector(
                                              onTap: _toggleDropdown,
                                              child: Icon(
                                                _showAccountDropdown
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down,
                                                color: Colors.black54,
                                                size: 40,
                                              ),
                                            )
                                          : null,
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                
                                AnimatedBuilder(
                                  animation: _dropdownAnimation,
                                  builder: (context, child) {
                                    return ClipRect(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        heightFactor: _dropdownAnimation.value,
                                        child: Container(
                                          width: double.infinity,
                                          height: _calculateDropdownHeight(),
                                          margin: EdgeInsets.only(top: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.symmetric(vertical: 8),
                                              itemCount: _savedAccounts.length,
                                              separatorBuilder: (context, index) => Padding(
                                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                                child: Divider(
                                                  height: 1,
                                                  color: Colors.grey.shade200,
                                                  indent: 16,
                                                  endIndent: 16,
                                                ),
                                              ),
                                              itemBuilder: (context, index) {
                                                final account = _savedAccounts[index];
                                                return Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () => _selectAccount(account),
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 18,
                                                            backgroundColor: Color(0xff59a5c0),
                                                            child: Text(
                                                              account.email[0].toUpperCase(),
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 12),
                                                          Expanded(
                                                            child: Text(
                                                              account.email,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.black87,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () => _removeAccount(account.email),
                                                            borderRadius: BorderRadius.circular(20),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(4),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 18,
                                                                color: Colors.grey.shade600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 20),
                            
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
                            
                            SizedBox(height: 6),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: Colors.black,
                                      checkColor: Colors.white,
                                      fillColor: WidgetStateProperty.resolveWith(
                                        (states) => states.contains(WidgetState.selected)
                                            ? Colors.black
                                            : Colors.transparent,
                                      ),
                                      side: BorderSide(color: Colors.black54),
                                    ),
                                    Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: _navigateToForgotPassword,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 20),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ),
                            
                            SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToSignUp,
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff59a5c0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  @override
  void dispose() {
    _dropdownAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }
}