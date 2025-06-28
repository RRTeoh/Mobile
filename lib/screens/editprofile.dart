import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asgm1/screens/membership.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';


class EditProfile extends StatefulWidget {
  final String initialFirstName;
  final String initialSecondName;
  final String initialEmail;
  final String initialDob;
  final String initialPhone;
  final String initialAvatarUrl;

  const EditProfile({
    super.key,
    required this.initialFirstName,
    required this.initialSecondName,
    required this.initialEmail,
    required this.initialDob,   
    required this.initialPhone,
    required this.initialAvatarUrl,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool _isSaved = false;
  

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _currentAvatarUrl;



  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.initialFirstName;
    secondNameController.text = widget.initialSecondName;
    emailController.text = widget.initialEmail;
    dobController.text = widget.initialDob;
    phoneController.text = widget.initialPhone;
    _currentAvatarUrl = widget.initialAvatarUrl;
  }

  void dispose() {
    // Dispose controllers to free resources
    firstNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff8fd4e8),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

Future<String?> uploadToImgur(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(bytes);

  final response = await http.post(
    Uri.parse('https://api.imgur.com/3/image'),
    headers: {'Authorization': 'Client-ID 1c7272900a8c448'},
    body: {'image': base64Image},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['data']['link'];
  } else {
    print('Imgur upload failed: ${response.body}');
    return null;
  }
}

  void onSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'firstName': firstNameController.text.trim(),
        'secondName': secondNameController.text.trim(),
        'email': emailController.text.trim(),
        'dob': dobController.text.trim(),
        'phone': phoneController.text.trim(),
        //'avatar': _selectedImage != null ? _selectedImage!.path : '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          duration: Duration(seconds: 1),
        ),
      );

      setState(() {
        _isSaved = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pop(context, {
        'firstName': firstNameController.text.trim(),
        'secondName': secondNameController.text.trim(),
        'dob': dobController.text.trim(),
        'phone': phoneController.text.trim(),
        'avatar': _currentAvatarUrl ?? '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty
                     ? NetworkImage(_currentAvatarUrl!)
                    : const AssetImage('assets/images/noprofile.png')) as ImageProvider,
                  ),
                Positioned(
                   right: 4,
                   bottom: 4,
                   child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, color: Colors.white, size: 14),
                    ),
                   ),
                ),
                ],
              ),
              const SizedBox(height: 20),

              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'First Name',
                  labelStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: secondNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  labelText: 'Second Name',
                  labelStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                  labelStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: dobController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.cake),
                  labelText: 'Date of Birth',
                  hintText: 'DD/MM/YYYY',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  labelStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today, color: Color(0xff8fd4e8)),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text;
                    if (text.isEmpty) {
                      return newValue;
                    }
                    if (text.length <= 3) {
                      return newValue;
                    } else if (text.length <= 7) {
                      return TextEditingValue(
                        text: '${text.substring(0, 3)}-${text.substring(3)}',
                        selection: TextSelection.collapsed(offset: text.length + 1),
                      );
                    } else {
                      return TextEditingValue(
                        text: '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}',
                        selection: TextSelection.collapsed(offset: text.length + 2),
                      );
                    }
                  }),
                ],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Phone Number',
                  hintText: 'XXX-XXX-XXXX',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  labelStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Save button
              ElevatedButton(
                onPressed: _isSaved ? null : onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSaved ? Colors.lightBlue : const Color.fromARGB(255, 12, 0, 143),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  _isSaved ? 'Saved' : 'Save',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isSaved ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _selectedImage = File(pickedFile.path);
    });

    final link = await uploadToImgur(_selectedImage!);
    if (link != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'avatar': link,
        });
        setState(() {
          _currentAvatarUrl = link;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
    }
  }
}





}
