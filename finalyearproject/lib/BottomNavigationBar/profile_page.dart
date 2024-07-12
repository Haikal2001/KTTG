import 'package:finalyearproject/profile/help_support.dart';
import 'package:finalyearproject/profile/profile_detail.dart';
import 'package:finalyearproject/profile/settings_page.dart';
import 'package:finalyearproject/profile/subscription.dart';
import 'package:finalyearproject/profile/user_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalyearproject/authentication/travel.dart';

class ProfilePage extends StatelessWidget {
  final String email;

  const ProfilePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange, // Orange color for the AppBar
        automaticallyImplyLeading: false, // Remove the back arrow
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TravelPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: userProfileProvider.profileImageUrl.isNotEmpty
                  ? NetworkImage(userProfileProvider.profileImageUrl)
                  : null,
              child: userProfileProvider.profileImageUrl.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              userProfileProvider.displayName.isNotEmpty
                  ? userProfileProvider.displayName
                  : 'User Name', // Display user name if available
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Use black text color for readability
              ),
            ),
            const SizedBox(height: 10),
            Text(
              email, // Display the user's email
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey, // Use grey text color for readability
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.grey), // Use grey divider color for readability
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileDetailPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.subscriptions, color: Colors.black),
              title: const Text(
                'Subscription',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubscriptionPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.black),
              title: const Text(
                'Help & Support',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TravelPage()),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
