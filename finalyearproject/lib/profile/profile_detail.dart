import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile_provider.dart';
import 'edit_profile.dart';

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Profile Details'),
        backgroundColor: Colors.orange, // Orange color for the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
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
            ),
            const SizedBox(height: 20),
            Text('Username: ${userProfileProvider.displayName}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Full Name: ${userProfileProvider.fullName}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Bio: ${userProfileProvider.bio}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Address: ${userProfileProvider.address}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone Number: ${userProfileProvider.phoneNumber}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Birthday: ${userProfileProvider.birthday}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Gender: ${userProfileProvider.gender}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                  if (result != null) {
                    userProfileProvider.updateProfile(
                      displayName: result['displayName'],
                      fullName: result['fullName'],
                      bio: result['bio'],
                      address: result['address'],
                      phoneNumber: result['phoneNumber'],
                      birthday: result['birthday'],
                      gender: result['gender'],
                      profilePicture: result['profileImage'],
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Orange color for the button
                ),
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
