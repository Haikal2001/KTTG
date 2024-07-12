import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription_detail.dart';
import 'subscription_service.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    final isSubscribed = subscriptionService.isSubscribed;
    final selectedPlan = subscriptionService.selectedPlan;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Subscription'),
        backgroundColor: Colors.orange, // Orange color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Unlock Premium Features!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose a plan that best suits your needs and enjoy enhanced features like advanced navigation, exclusive content, and more!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            if (isSubscribed)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.withOpacity(0.3),
                ),
                child: Column(
                  children: [
                    Text(
                      'You are subscribed to the $selectedPlan plan',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Enjoy your premium features!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        subscriptionService.unsubscribe();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel Subscription',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              SubscriptionOption(
                icon: Icons.today,
                title: '1-Day Pass',
                price: 'RM 8',
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionDetailPage(plan: '1-Day Pass', price: 'RM 8'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SubscriptionOption(
                icon: Icons.calendar_today,
                title: 'Monthly Subscription',
                price: 'RM 40',
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionDetailPage(plan: 'Monthly Subscription', price: 'RM 40'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SubscriptionOption(
                icon: Icons.calendar_view_month,
                title: 'Yearly Subscription',
                price: 'RM 360',
                color: Colors.red,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubscriptionDetailPage(plan: 'Yearly Subscription', price: 'RM 360'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Enjoy your travel experience to the fullest with our premium plans!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String price;
  final Color color;
  final VoidCallback onPressed;

  const SubscriptionOption({
    required this.icon,
    required this.title,
    required this.price,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onPressed,
                child: const Text(
                  'Subscribe',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
