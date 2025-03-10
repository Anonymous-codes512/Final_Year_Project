import 'package:final_year_project/child_pages/Kids_screens/games/car_game/car_game.dart';
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

  // Check if user can play the level (3 times per day)
  Future<bool> _canPlayLevel(String level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String key = '${widget.userId}_$level';

    int playCount = prefs.getInt('$key-count') ?? 0;
    String lastPlayed = prefs.getString('$key-date') ?? '';

    // Reset if the date has changed
    if (lastPlayed != today) {
      await prefs.setString('$key-date', today);
      await prefs.setInt('$key-count', 0);
      playCount = 0;
    }

    return playCount < 3;
  }

  // Increment play count after playing
  Future<void> _incrementPlayCount(String level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String key = '${widget.userId}_$level';

    int playCount = prefs.getInt('$key-count') ?? 0;
    await prefs.setString('$key-date', today);
    await prefs.setInt('$key-count', playCount + 1);
  }

  // Show dialog when limit is reached
  void _showLimitDialog(BuildContext context, String level) {
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

  // Build Level Card
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
        if (await _canPlayLevel(level)) {
          await _incrementPlayCount(level);
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
          _showLimitDialog(context, level);
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
