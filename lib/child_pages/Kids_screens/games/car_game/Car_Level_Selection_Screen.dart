import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/car_game/car_game.dart';
import 'package:final_year_project/child_pages/check_subscription.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CarLevelSelectionScreen extends StatefulWidget {
  final String userId;
  final String parentEmail;
  const CarLevelSelectionScreen({
    required this.userId,
    required this.parentEmail,
    super.key,
  });

  @override
  _CarLevelSelectionScreenState createState() =>
      _CarLevelSelectionScreenState();
}

class _CarLevelSelectionScreenState extends State<CarLevelSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Level Selection',
          style: TextStyle(color: Color(0xffffffff)),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 77, 77),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 251, 196, 196),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Header Animation
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Lottie.asset('assets/animation/Animation2.json'),
                    ),
                    const SizedBox(height: 25),

                    _buildLevelCard(
                      context,
                      'Easy',
                      Icons.looks_one,
                      'Start with simple levels!',
                      Colors.green.shade400,
                      'Easy',
                      'assets/games/green car.png',
                    ),
                    const SizedBox(height: 20),
                    _buildLevelCard(
                      context,
                      'Medium',
                      Icons.looks_two,
                      'Challenge yourself a bit more!',
                      Colors.orange.shade400,
                      'Medium',
                      'assets/games/orange car.png',
                    ),
                    const SizedBox(height: 20),
                    _buildLevelCard(
                      context,
                      'Hard',
                      Icons.trending_up,
                      'Get ready for tough challenges!',
                      Colors.red.shade400,
                      'Hard',
                      'assets/games/red car.png',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Updated _loadPlayCount function with debugging
  Future<void> _loadPlayCount(String level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int playLimit = await _fetchPlayLimitFromFirestore(level);

    // Log the fetched play limit for debugging
    print("Fetched play limit from Firestore for $level: $playLimit");

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String key = '${widget.userId}_$level';

    int playCount = prefs.getInt('$key-count') ?? 0;
    String lastPlayed = prefs.getString('$key-date') ?? '';

    // Debugging: Log the current play count and last played date
    print("Current play count for $level: $playCount");
    print("Last played date for $level: $lastPlayed");

    // Reset if the date has changed
    if (lastPlayed != today) {
      await prefs.setString('$key-date', today);
      await prefs.setInt('$key-count', 0);
      playCount = 0;

      // Debugging: Log the reset action
      print("Reset play count for $level. New play count: $playCount");
    }

    if (playCount >= playLimit) {
      _showLimitDialog(
          context, level); // Show the limit dialog if max limit is reached
    }
  }

// Fetch play limit from Firestore for catch_the_ball levels with debugging
  Future<int> _fetchPlayLimitFromFirestore(String level) async {
    int playLimit = 3; // Default limit if not found in Firestore
    print('$level😒😒😒😒😒😒');
    try {
      final parentDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.parentEmail)
          .get();

      if (parentDoc.docs.isNotEmpty) {
        final parentData = parentDoc.docs.first.data();

        // Debugging: Log parent data fetched from Firestore
        print("Fetched parent data from Firestore: $parentData");

        // Check for 'catch_the_ball' levels
        if (parentData.containsKey('catch_the_ball-${level.toLowerCase()}')) {
          playLimit = parentData['catch_the_ball-${level.toLowerCase()}']
                  ?['Limit'] ??
              3;

          // Debugging: Log the fetched limit for the current level
          print("Fetched play limit for $level: $playLimit");
        }
      }
    } catch (e) {
      print("⚠️ Error fetching play limit from Firestore: $e");
    }

    return playLimit;
  }

// Increment play count after playing with debugging
  Future<void> _incrementPlayCount(String level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String key = '${widget.userId}_$level';

    int playCount = prefs.getInt('$key-count') ?? 0;

    // Debugging: Log the current play count before incrementing
    print("Current play count for $level before increment: $playCount");

    await prefs.setString('$key-date', today);
    await prefs.setInt('$key-count', playCount + 1);

    // Debugging: Log the updated play count after incrementing
    print("Incremented play count for $level: ${playCount + 1}");
  }

// Show dialog when limit is reached with debugging
  void _showLimitDialog(BuildContext context, String level) {
    // Debugging: Log when the limit dialog is shown
    print(
        "Showing limit dialog for $level because the daily limit was reached.");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Daily Limit Reached"),
          content: Text(
              "You have already played the $level level 3 times today. Come back tomorrow!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

// Updated _buildLevelCard to use new logic with debugging
  Widget _buildLevelCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    Color color,
    String level,
    String carImage,
  ) {
    return GestureDetector(
      onTap: () async {
        // Debugging: Log when a level card is tapped
        print("Tapped on level: $level");

        await _loadPlayCount(
            level); // Check the play count limit before navigating

        SharedPreferences prefs = await SharedPreferences.getInstance();
        int playLimit = await _fetchPlayLimitFromFirestore(level);

        String key = '${widget.userId}_$level';
        int playCount = prefs.getInt('$key-count') ?? 0;

        // Debugging: Log the play count before making the decision to navigate
        print(
            "Play count for $level: $playCount, Play limit for $level: $playLimit");
        if (level == 'Hard') {
          if (playCount < playLimit) {
            await _incrementPlayCount(level.toLowerCase());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckSubscriptionScreen(
                  parentEmail: widget.parentEmail,
                  themeColor: color,
                  level: level,
                  userId: widget.userId,
                  gameName: 'catch_the_ball',
                  carImage: carImage,
                ),
              ),
            );
          } else {
            _showLimitDialog(context, level);
          }
        } else {
          if (playCount < playLimit) {
            await _incrementPlayCount(level); // Increment the play count
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KidCarGame(
                  level: level,
                  carImage: carImage,
                  userId: widget.userId,
                  parentEmail: widget.parentEmail,
                ),
              ),
            );
          } else {
            _showLimitDialog(
                context, level); // Show limit dialog if max limit reached
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
