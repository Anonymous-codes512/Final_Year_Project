import 'package:final_year_project/Authentication/Not_Found.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Authentication/splash_screen.dart';
import 'firebase_options.dart';
import 'package:final_year_project/Authentication/login_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Activate Firebase App Check with debug provider.
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug, // For iOS, if applicable.
  );

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
          builder: (context) => NotFoundPage(),
        );
      },
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: SplashScreen(),
    );
  }
}

// Debug Device = ab2997ec-981f-435e-a87a-8d9d99086f7a
