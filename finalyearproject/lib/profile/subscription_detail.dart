import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription_service.dart';
import 'subscription_success_dialog.dart';

class SubscriptionDetailPage extends StatelessWidget {
  final String plan;
  final String price;

  const SubscriptionDetailPage({super.key, required this.plan, required this.price});

  void _subscribe(BuildContext context) {
    Provider.of<SubscriptionService>(context, listen: false).subscribe(plan);
    Navigator.pop(context);
    showSubscriptionSuccessDialog(context, plan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: Text('Subscribe to $plan'),
        backgroundColor: Colors.orange, // Orange color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'You have chosen the $plan plan',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: $price',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select a payment method:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            PaymentOption(
              icon: Icons.credit_card,
              title: 'Credit Card',
              onPressed: () => _subscribe(context),
            ),
            const SizedBox(height: 20),
            PaymentOption(
              icon: Icons.account_balance_wallet,
              title: 'Online Banking',
              onPressed: () => _subscribe(context),
            ),
            const SizedBox(height: 20),
            PaymentOption(
              icon: Icons.paypal,
              title: 'Touch n Go eWallet',
              onPressed: () => _subscribe(context),
            ),
            const SizedBox(height: 30),
            const Text(
              'Secure payments powered by Flutter Payment Gateway.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const PaymentOption({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.orange,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: const Text(
            'Pay',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
