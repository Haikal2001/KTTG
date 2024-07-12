import 'package:flutter/material.dart';

Future<void> showSubscriptionSuccessDialog(BuildContext context, String plan) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // User can tap outside to dismiss
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'CONGRATULATIONS',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Icon(
                Icons.check_circle_outline,
                color: Colors.orange,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Subscription activated',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Congratulations, you have successfully activated the $plan plan!',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FeatureIcon(
                    icon: Icons.navigation,
                    label: 'Real-Time\nNavigation',
                  ),
                  FeatureIcon(
                    icon: Icons.directions_car,
                    label: 'Distance\nTrips',
                  ),
                  FeatureIcon(
                    icon: Icons.access_time,
                    label: 'Estimated\nTime',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.orange.withOpacity(0.1),
          child: Icon(icon, size: 30, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
