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



// {
//   age: 10,
//   childId: "C2FBIgHfrYPGrgPd3paujbHpHqf1",
//   email: "anonymouscode786@gmail.com"
//   name: "Hassan", 
//   role: "child",
//   gameData: {
//     additionGame: {
//       level_Medium: [{score: 300, timestamp: 25-02-2025}],
//       level_Advanced: [{score: 110, timestamp: 25-02-2025}, {score: 80, timestamp: 26-02-2025}, {score: 80, timestamp: 26-02-2025}]
//       },
//     catch_the_ball: {
//       level_Hard: {highestScore: 87, lastScores: [{date: 26-02-2025, score: 7}, {date: 26-02-2025, score: 33}, {date: 26-02-2025, score: 47}, {date: 26-02-2025, score: 50}, {date: 26-02-2025, score: 87}]},
//       level_Medium: {highestScore: 46, lastScores: [{date: 26-02-2025, score: 24}, {date: 26-02-2025, score: 46}]},
//       level_Easy: {highestScore: 13, lastScores: [{date: 25-02-2025, score: 13}]}
//       },
//     shape_game: {
//       level_Easy: {scores: [{date: 25-02-2025, score: 6}, {date: 25-02-2025, score: 8}], highestScore: 8}}
//   }
// }

// {
//   age : 15
//   childId : "tRbHycdGEWaQ7F0hmSQf5V9Wog02"
//   email : "1brain1bug@gmail.com"
//   name : "Hussain"
//   role : "child"
//   gameData{
//     quiz{
//       level_1{
//         {date : "25-02-2025" , score : 0}
//         {date : "25-02-2025", score : 5}
//       }
//       level_2{
//         {date : "25-02-2025", score: 1}
//       }
//       level_3{
//         {date : "25-02-2025", score : 2}
//       }
//     }
//   }
// }