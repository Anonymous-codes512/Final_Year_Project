import 'package:final_year_project/child_pages/check_subscription.dart';
import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Map<String, int> levelLimits = {}; // Map to store level limits

  @override
  void initState() {
    super.initState();
    _initializeLevelData();
  }

  Future<void> _initializeLevelData() async {
    await _loadLevelLimits();
    await _loadLevelCounts();
  }

  // Load play counts from SharedPreferences
  Future<void> _loadLevelLimits() async {
    final prefs = await SharedPreferences.getInstance();
    final parentEmail = widget.parentEmail.toLowerCase().trim();
    levelLimits.clear();

    try {
      final parentDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: parentEmail)
          .get();

      if (parentDoc.docs.isNotEmpty) {
        final parentData = parentDoc.docs.first.data();

        parentData.forEach((key, value) {
          // Ensure we process keys related to any game with 'game-level' format
          if (key.contains('-') && value is Map && value.containsKey('Limit')) {
            String level =
                key.split('-')[1]; // Extract 'easy', 'medium', or 'hard'
            int limit = value['Limit'];

            // Debugging log to check what keys are being processed
            print("Processing limit for $key: $limit");

            // Only process limits for games, so we store them
            if (key.startsWith('AdditionaGame-')) {
              levelLimits[level] = limit;
              print("Set limit for AdditionaGame-$level: $limit"); // Debug log
            } else if (key.startsWith('catch_the_ball-')) {
              levelLimits[level] = limit;
              print("Set limit for catch_the_ball-$level: $limit"); // Debug log
            } else if (key.startsWith('shape_game-')) {
              levelLimits[level] = limit;
              print("Set limit for shape_game-$level: $limit"); // Debug log
            }

            // Save to SharedPreferences for fallback
            prefs.setInt('${widget.userId}_$key', limit);
          }
        });
      } else {
        print("🚨 Parent document not found in Firestore.");
      }
    } catch (e) {
      print("⚠️ Error fetching limits from Firestore: $e");
    }

    // Debugging log to check if limits are loaded correctly
    print("Level Limits: $levelLimits");

    setState(() {});
  }

  Future<void> _loadLevelCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    levelPlayCount.clear();

    for (var level in levelLimits.keys) {
      int count =
          prefs.getInt('${widget.userId}_additionaGame_${level}_$today') ?? 0;
      levelPlayCount[level] = count;

      // Debugging log to show the count for each level
      print("Level '$level' played count for today: $count");
    }

    setState(() {});
  }

  Future<void> _incrementLevelCount(String level) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = '${widget.userId}_additionaGame_${level}_$today';
    int count = (levelPlayCount[level] ?? 0);

    // Debugging log before increment
    print("Before increment: Level '$level' count = $count");

    count += 1;
    await prefs.setInt(key, count);

    setState(() {
      levelPlayCount[level] = count;
    });

    // Debugging log after increment
    print("After increment: Level '$level' count = $count");
  }

  // Show popup when daily limit is reached
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
      body: SingleChildScrollView(
        child: Container(
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
                    // _buildLevelCard(
                    //   context,
                    //   'Advanced',
                    //   Icons.star,
                    //   'Only for the best players!',
                    //   Colors.red.shade400,
                    //   'Advanced',
                    // ),
                  ],
                ),
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
        await _initializeLevelData(); // Always fetch fresh data

        int levelLimit = levelLimits[level.toLowerCase()] ?? 3;
        int playedCount = levelPlayCount[level.toLowerCase()] ?? 0;

        // Debugging log to show the current level limit and count
        print(
            "Checking level '$level' - Limit: $levelLimit, Played count: $playedCount");

        if (level == 'Hard') {
          if (playedCount < levelLimit) {
            await _incrementLevelCount(level.toLowerCase());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckSubscriptionScreen(
                  parentEmail: widget.parentEmail,
                  themeColor: color,
                  level: level,
                  userId: widget.userId,
                  gameName: 'Additional_game',
                ),
              ),
            );
          } else {
            _showLimitPopup(level);
          }
        } else {
          if (playedCount < levelLimit) {
            await _incrementLevelCount(level.toLowerCase());
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
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
