import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class KidsLevelScreen extends StatefulWidget {
  final String userId;
  final String parentEmail;

  const KidsLevelScreen(
      {required this.userId, required this.parentEmail, super.key});

  @override
  _KidsLevelScreenState createState() => _KidsLevelScreenState();
}

class _KidsLevelScreenState extends State<KidsLevelScreen> {
  Map<String, int> levelPlayCount = {};

  @override
  void initState() {
    super.initState();
    _loadLevelCounts();
  }

  Future<void> _loadLevelCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    for (var level in ['Easy', 'Medium', 'Hard', 'Advanced']) {
      levelPlayCount[level] =
          prefs.getInt('${widget.userId}_$level\_$today') ?? 0;
    }
    setState(() {});
  }

  Future<void> _incrementLevelCount(String level) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = '${widget.userId}_$level\_$today';
    int count = (prefs.getInt(key) ?? 0) + 1;
    await prefs.setInt(key, count);
    setState(() {
      levelPlayCount[level] = count;
    });
  }

  void _showLimitPopup(String level) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Daily Limit Reached'),
          content: Text(
              'You have reached the daily limit for $level level! Try again tomorrow.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 225,
                    width: double.infinity,
                    child: Lottie.asset('assets/animation/Animation1.json'),
                  ),
                  _buildLevelCard(
                    context,
                    'Easy',
                    Icons.looks_one,
                    'Start with simple levels!',
                    Colors.green.shade400,
                    'Easy',
                  ),
                  const SizedBox(height: 15),
                  _buildLevelCard(
                    context,
                    'Medium',
                    Icons.looks_two,
                    'Challenge yourself a bit more!',
                    Colors.blue.shade400,
                    'Medium',
                  ),
                  const SizedBox(height: 15),
                  _buildLevelCard(
                    context,
                    'Hard',
                    Icons.trending_up,
                    'Get ready for tough challenges!',
                    Colors.orange.shade400,
                    'Hard',
                  ),
                  const SizedBox(height: 15),
                  _buildLevelCard(
                    context,
                    'Advanced',
                    Icons.star,
                    'Only for the best players!',
                    Colors.red.shade400,
                    'Advanced',
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
    String level,
  ) {
    return GestureDetector(
      onTap: () async {
        if ((levelPlayCount[level] ?? 0) < 3) {
          await _incrementLevelCount(level);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(
                level: level,
                themeColor: color,
                userId: widget.userId,
                parentEmail: widget.parentEmail,
              ),
            ),
          );
        } else {
          _showLimitPopup(level);
        }
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
