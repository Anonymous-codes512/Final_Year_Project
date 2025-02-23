import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'package:lottie/lottie.dart';

class KidsLevelScreen extends StatefulWidget {
  const KidsLevelScreen({super.key});

  @override
  _KidsLevelScreenState createState() => _KidsLevelScreenState();
}

class _KidsLevelScreenState extends State<KidsLevelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Selection'),
        backgroundColor: const Color(0xFFF9D77E),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFFBF8C4),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 40, bottom: 16),
              // padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header
                  SizedBox(
                    height: 225,
                    width: double.infinity,
                    child: Lottie.asset('assets/animation/Animation1.json'),
                  ),
                  // Level Cards
                  _buildLevelCard(
                    context,
                    'Easy',
                    Icons.looks_one,
                    'Start with simple levels!',
                    Colors.green.shade400,
                    GameScreen(
                      level: 'Easy',
                      themeColor: Colors.green.shade400,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildLevelCard(
                    context,
                    'Medium',
                    Icons.looks_two,
                    'Challenge yourself a bit more!',
                    Colors.blue.shade400,
                    GameScreen(
                        level: 'Medium', themeColor: Colors.blue.shade400),
                  ),
                  const SizedBox(height: 15),
                  _buildLevelCard(
                    context,
                    'Hard',
                    Icons.trending_up,
                    'Get ready for tough challenges!',
                    Colors.orange.shade400,
                    GameScreen(
                      level: 'Hard',
                      themeColor: Colors.orange.shade400,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildLevelCard(
                    context,
                    'Advanced',
                    Icons.star,
                    'Only for the best players!',
                    Colors.red.shade400,
                    GameScreen(
                      level: 'Advanced',
                      themeColor: Colors.red.shade400,
                    ),
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
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    Color color,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(93, 125, 125, 125),
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          shadowColor: const Color(0xD1CBCBCB),
          color: color.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
