import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange, // Orange color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.black),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                // Implement notification settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.black),
              title: const Text('Privacy'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                // Implement privacy settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.black),
              title: const Text('Language'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                // Implement language settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.black),
              title: const Text('About'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                // Implement about information
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.black),
              title: const Text('Help'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                // Implement help section
              },
            ),
          ],
        ),
      ),
    );
  }
}
