import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_year_project/Authentication/login_screen.dart';
import 'package:final_year_project/child_pages/Teenager/quiz/quiz.dart';
import 'package:final_year_project/child_pages/Teenager/quiz/quiz_level_2.dart';
import 'package:final_year_project/child_pages/Teenager/quiz/quiz_level_3.dart';

class LevelScreen extends StatefulWidget {
  final String uid;
  final String parentEmail;

  const LevelScreen({super.key, required this.uid, required this.parentEmail});

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int playCount = 0;
  static const int maxPlays = 3;

  @override
  void initState() {
    super.initState();
    _loadPlayCount();
  }

  Future<void> _loadPlayCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playCount = prefs.getInt('playCount_${widget.uid}') ?? 0;
    });
  }

  Future<void> _incrementPlayCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playCount++;
    });
    await prefs.setInt('playCount_${widget.uid}', playCount);
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Play Limit Reached"),
        content: const Text(
            "You have reached the maximum of 3 plays for today. Try again tomorrow!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _handlePlay(VoidCallback navigateToQuiz) {
    if (playCount >= maxPlays) {
      _showLimitDialog();
    } else {
      _incrementPlayCount();
      navigateToQuiz();
    }
  }

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
        backgroundColor: const Color(0xFF373E37),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, const Color(0xFFEDE7F6)],
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
                  _buildLevelCard(
                    'Level 1',
                    Icons.looks_one,
                    'Beginner Quiz',
                    const Color(0xFFffde59),
                    () => _handlePlay(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            level: 1,
                            uid: widget.uid,
                            parentEmail: widget.parentEmail,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  _buildLevelCard(
                    'Level 2',
                    Icons.looks_two,
                    'Intermediate Quiz',
                    const Color(0xFF373e37),
                    () => _handlePlay(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen2(
                            level: 2,
                            uid: widget.uid,
                            parentEmail: widget.parentEmail,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  _buildLevelCard(
                    'Level 3',
                    Icons.looks_3,
                    'Advanced Quiz',
                    const Color(0xFFffde59),
                    () => _handlePlay(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiplicationQuizPage(
                            level: 3,
                            uid: widget.uid,
                            parentEmail: widget.parentEmail,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(
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
