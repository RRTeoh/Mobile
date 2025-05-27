// lib/details/settings.dart
import 'package:flutter/material.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings),
                const SizedBox(width: 10),
                const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            _buildItem(Icons.help_outline, "Help Center"),
            _buildItem(Icons.account_circle, "Manage Account"),
            _buildItem(Icons.lock_outline, "Privacy Settings"),
            _buildItem(Icons.notifications, "Notifications"),
            _buildItem(Icons.language, "Language"),
            _buildItem(Icons.logout, "Logout"),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
