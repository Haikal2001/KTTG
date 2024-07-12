import 'package:finalyearproject/authentication/firebase_option.dart';
import 'package:finalyearproject/authentication/homescreen.dart';
import 'package:finalyearproject/authentication/splash_screen.dart';
import 'package:finalyearproject/authentication/travel.dart';
import 'package:finalyearproject/profile/subscription_service.dart';
import 'package:finalyearproject/profile/user_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(), // Use AuthWrapper as the home widget
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplash = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _showSplash = true;
        });
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _showSplash = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen(email: ''); // Show splash screen for logged-in users
    } else {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Or another loading screen
          } else if (snapshot.hasData) {
            return HomeScreen(email: snapshot.data!.email ?? ''); // User is logged in
          } else {
            return const TravelPage(); // User is not logged in
          }
        },
      );
    }
  }
}
