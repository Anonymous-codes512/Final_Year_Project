import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/shape_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShapeSplashScreen extends StatefulWidget {
  final String userId;
  final String parentEmail;
  const ShapeSplashScreen(
      {required this.userId, required this.parentEmail, super.key});

  @override
  _ShapeSplashScreenState createState() => _ShapeSplashScreenState();
}

class _ShapeSplashScreenState extends State<ShapeSplashScreen> {
  int playCount = 0;
  final int maxPlays = 3;

  @override
  void initState() {
    super.initState();
    _loadPlayCount();
  }

  Future<void> _loadPlayCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      playCount = prefs.getInt('shape_game_play_count') ?? 0;
    });
  }

  Future<void> _incrementPlayCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('shape_game_play_count', playCount + 1);
    setState(() {
      playCount++;
    });
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Play Limit Reached"),
        content: const Text(
            "You have reached the maximum play limit of 3 times. Please try again later!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _startGame() {
    if (playCount >= maxPlays) {
      _showLimitDialog();
    } else {
      _incrementPlayCount();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShapeScreen(
            userId: widget.userId,
            parentEmail: widget.parentEmail,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/kids/games/shapes_background.gif',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF9AD0EC).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Guess the Shape',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Test your shape recognition skills! You will be shown different shapes, and you must correctly identify them.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(color: Color(0xFF5B6D5B)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
