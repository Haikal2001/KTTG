import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.orange, // Orange color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FAQs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ExpansionTile(
                title: const Text('How to use the app?'),
                children: [
                  SizedBox(
                    height: 300, // Adjust the height as needed
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'How to Use the App\n\n'
                        '1) Search for Locations:\n\n'
                        'On the home screen, you can search for the location you want to discover by typing the name of the place.\n\n'
                        'Explore by Categories:\n'
                        'If you\'re unsure where to go, you can browse places based on categories available on the home screen, such as:\n'
                        'Stay for accommodation\n'
                        'Food and Drink for meals\n'
                        'History for historical sites\n'
                        'Shop for shopping\n\n'
                        '2) Recommendation Function:\n'
                        'The special feature of this app is its recommendation function, which suggests places based on your preferences or similar places you like.\n'
                        'Steps:\n'
                        'a. You can search for places by entering their names. The app will then recommend similar places.\n'
                        'b. You can also insert tags or keywords based on your preferences. For example, type "Affordable," and the app will recommend places based on that preference.\n'
                        'c. If you don\'t want to search, you can manually select your preferences by clicking on tag categories. It will display several tags that might match your interests. You can choose one or more tags as your preferences, click save, and you will receive recommendations.\n\n'
                        '3) Favorite Places:\n'
                        'You can add places you find attractive to your favorites list. The favorite places will be stored on the favorites page.\n\n'
                        '4) Search History:\n'
                        'You can view your previous searches by navigating to the search history page. You can clear the history by either removing all or selecting specific places to delete. Clear history by clicking the settings icon at the top corner of the search history page.\n\n'
                        '5) Profile Management:\n'
                        'If you have time, you can manage your profile on the profile page. Here, you can update your personal information and access your gallery to set up your profile picture, making your app experience more personalized and attractive.',
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('How Content-Based Filtering works in KTTG Mobile App'),
                children: [
                  SizedBox(
                    height: 300, // Adjust the height as needed
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'How Content-Based Filtering works in KTTG Mobile App\n\n'
                        'Project Title: Personalized Travel Experiences in Kuala Terengganu: Implementing Content-Based Filtering in KTTG Mobile Tourism App\n\n'
                        'Algorithm: Content-Based Filtering\n\n'
                        'Domain: Tourism\n\n'
                        'Area of Interest (AOI): Travel Recommendation Systems\n\n'
                        'Research Focus: Enhancing personalized travel recommendations, optimizing user satisfaction and engagement with tailored travel experiences.\n\n'
                        'Real-World Problems: Improving the discovery of lesser-known attractions, managing tourist overcrowding at popular sites.\n\n'
                        'Content-Based Filtering in KTTG mobile app works by analyzing the attributes of various tourist attractions and matching them with the user’s preferences. Here’s how it functions:\n\n'
                        '1) User Preferences: When users interact with the app, they provide information about their preferences, such as interests in cultural sites, food, adventure activities, etc. This data can be collected through direct input or inferred from user behavior.\n\n'
                        '2) Attribute Analysis: The app contains a database of tourist attractions, each tagged with specific attributes (e.g., type of attraction, amenities, popularity, etc.).\n\n'
                        '3) Matching Algorithm: The Content-Based Filtering algorithm compares the attributes of available attractions with the user’s preferences. It scores each attraction based on how well it matches the user\'s profile.\n\n'
                        '4) Recommendation Generation: Attractions with the highest scores are recommended to the user. These recommendations are tailored to enhance the user’s travel experience by suggesting places that align with their interests.\n\n'
                        '5) Continuous Learning: As users continue to use the app, the algorithm refines its recommendations by learning from user feedback and interactions, ensuring that the suggestions remain relevant and personalized.\n\n'
                        '6) Benefits: This approach not only helps users discover lesser-known attractions but also aids in managing tourist overcrowding at popular sites by distributing visitors more evenly across various attractions. This leads to a more satisfying and unique travel experience for users.',
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('How to contact support?'),
                children: [
                  SizedBox(
                    height: 300, // Adjust the height as needed
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'How to Contact Support\n\n'
                        'If you encounter any issues while using the Travel Guide app, or if you have any questions or feedback, there are several ways you can reach our support team:\n\n'
                        '1) Email Support:\n'
                        'You can email us at KTGG@travelguide.com for any queries or issues. Our support team typically responds within 24-48 hours. Please provide detailed information about your issue to help us assist you better.\n\n'
                        '2) Phone Support:\n'
                        'You can call our support hotline at +6013-4446568. Our phone support is available from 9 AM to 6 PM (GMT) from Monday to Friday. We are happy to assist you with any immediate concerns.\n\n'
                        '3) Live Chat Support:\n'
                        'For real-time assistance, you can use our live chat feature available within the app. Tap on the "Live Chat" option to start chatting with one of our support representatives. Live chat is available 24/7.\n\n'
                        '4) FAQ Section:\n'
                        'Before reaching out to our support team, you might find the answer to your question in our FAQ section. This section covers the most common questions and issues faced by our users and provides step-by-step solutions.\n\n'
                        '5) Feedback Form:\n'
                        'If you have suggestions on how we can improve the app, you can fill out our feedback form available under the "Contact Us" section in the app. We appreciate your feedback and strive to make the Travel Guide app better for everyone.\n\n'
                        'We are committed to providing you with the best possible support to ensure you have a great experience using the Travel Guide app.',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: const Text('KTTG@travelguide.com'),
                onTap: () {
                  // Implement email functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: const Text('+6013-4446568'),
                onTap: () {
                  // Implement phone call functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Live Chat'),
                onTap: () {
                  // Implement live chat functionality here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: HelpSupportPage()));
}
