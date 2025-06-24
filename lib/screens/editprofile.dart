import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  final String initialFirstName;
  final String initialSecondName;
  final String initialEmail;
  //final String initialDob;
  //final String initialPhone;

  const EditProfile({
    super.key,
    required this.initialFirstName,
    required this.initialSecondName,
    required this.initialEmail,
    //required this.initialDob,
    //required this.initialPhone,
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

  @override

  void initState() {
  super.initState();
  firstNameController.text = widget.initialFirstName;
  secondNameController.text = widget.initialSecondName;
  
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

void onSave() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final uid = user.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'firstName': firstNameController.text,
      'secondName': secondNameController.text,
      'email': emailController.text,
      'dob': dobController.text,
      'phone': phoneController.text,
    }, SetOptions(merge: true)); // merge = true to update only the fields

    // Return values to ProfilePage
    Navigator.pop(context, {
      'firstName': firstNameController.text,
      'secondName': secondNameController.text,
      'email': emailController.text,
      'dob': dobController.text,
      'phone': phoneController.text,
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
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/Profile.png'),
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
                  //hintText: widget.initialEmail,
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
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.cake),
                  labelText: 'Date of Birth',
                  //hintText: widget.initialDob,
                  labelStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Phone Number',
                  //hintText: widget.initialDob,
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
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 12, 0, 143),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
