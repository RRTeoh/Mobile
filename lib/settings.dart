import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPanel extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: SingleChildScrollView( // Ensure scrolling if content overflows
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.settings),
                  const SizedBox(width: 10),
                  const Text("Settings",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              _buildItem(Icons.help_outline, "Help Center"),
              _buildItem(Icons.account_circle, "Manage Account"),
              _buildItem(Icons.lock_outline, "Privacy Settings"),
              _buildItem(Icons.notifications, "Notifications"),
              _buildItem(Icons.language, "Language"),
              _buildItem(
                Icons.logout,
                "Logout",
                onTap: () {
                  print("Logout tapped");
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        title: const Center(
          child: Text(
            "Logout Confirmation",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey, 
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 16.0), 
          child: Text(
            "Confirm Logout?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue, 
              fontSize: 15,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly, 
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                ), 
            ),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.black,
              fontSize: 18,), 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
