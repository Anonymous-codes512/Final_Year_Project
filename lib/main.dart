import 'package:final_year_project/Authentication/Not_Found.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Authentication/splash_screen.dart';
import 'firebase_options.dart';
import 'package:final_year_project/Authentication/Login_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMind', // Set your initial route (if any)
      routes: {
        '/login': (context) => LoginPage(), // Define the login route
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) =>
                NotFoundPage()); // Handle unknown routes if needed
      },
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: SplashScreen(),
    );
  }
}
