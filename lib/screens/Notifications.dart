import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool showNotifications = true;
  bool showIconBadges = false;
  bool floatingNotifications = false;
  bool lockScreenNotifications = false;
  bool allowSound = true;
  bool allowVibration = false;
  bool allowLED = false;

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
          "Notifications",
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
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )]
              ),
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _switchTile("Show notifications", showNotifications, (val) {
                setState(() => showNotifications = val);
              }),
              const Divider(
                color: Colors.grey,
              ),
              _switchTile("Show app icon badges", showIconBadges, (val) {
                setState(() => showIconBadges = val);
              }),
              _switchTile("Floating notifications", floatingNotifications, (val) {
                setState(() => floatingNotifications = val);
              }, subtitle: "Allow floating notifications"),
              _switchTile("Lock screen notifications", lockScreenNotifications, (val) {
                setState(() => lockScreenNotifications = val);
              }, subtitle: "Allow notifications on the Lock screen"),
              _switchTile("Allow sound", allowSound, (val) {
                setState(() => allowSound = val);
              }),
              _switchTile("Allow vibration", allowVibration, (val) {
                setState(() => allowVibration = val);
              }),
              _switchTile("Allow using LED light", allowLED, (val) {
                setState(() => allowLED = val);
              }),
              const SizedBox(height: 20),
              //   const Divider(
              //   color: Colors.grey,
              // ),              
            ],)
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged, {String? subtitle}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.black.withOpacity(0.5)))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.lightGreenAccent,
        inactiveThumbColor: Colors.grey.shade700,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }
}
