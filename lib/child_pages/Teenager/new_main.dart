import 'package:final_year_project/Authentication/login_screen.dart';
import 'package:final_year_project/child_pages/Teenager/quiz/quiz.dart';
import 'package:final_year_project/child_pages/Teenager/quiz/quiz_level2.dart';
import 'package:final_year_project/child_pages/Teenager/quiz/quiz_level3.dart';
import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teenagers Quiz Panel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF373E37), // Black shade as per #373e37
        elevation: 4,
        actions: [
          // Sign out button in the AppBar
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      // Background Gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEDE7F6)], // Soft gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Select Test Level',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF373E37),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Level 1 Button
                  _buildLevelCard(
                    context,
                    'Level 1',
                    Icons.looks_one,
                    'Beginner Quiz',
                    const Color(0xFFffde59), // Yellow shade #ffde59
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Quiz_Screen(level: 1),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Level 2 Button
                  _buildLevelCard(
                    context,
                    'Level 2',
                    Icons.looks_two,
                    'Intermediate Quiz',
                    const Color(0xFF373e37), // Dark color for contrast
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Quiz_Screen2(level: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Level 3 Button
                  _buildLevelCard(
                    context,
                    'Level 3',
                    Icons.looks_3,
                    'Advanced Quiz',
                    const Color(0xFFffde59), // Yellow shade #ffde59
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiplicationQuizPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom Card Builder for Levels
  Widget _buildLevelCard(
    BuildContext context,
    String level,
    IconData icon,
    String description,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        shadowColor: Colors.black26,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
