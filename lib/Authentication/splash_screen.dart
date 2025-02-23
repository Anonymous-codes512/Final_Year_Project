import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to LoginScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFAF7), // Beige background color
      body: Center(
        child: Stack(
          alignment: Alignment.center, // Align text in the center of the GIF
          children: [
            // Centered GIF
            SizedBox(
              width: 350, // Adjust width of the GIF
              height: 350, // Adjust height of the GIF
              child: Image.asset(
                'assets/splash_picture.png', // Replace with your actual GIF path
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
