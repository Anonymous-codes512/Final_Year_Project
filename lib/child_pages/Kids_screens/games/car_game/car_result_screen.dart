import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'car_game.dart';

class CarResultScreen extends StatefulWidget {
  final int score;

  const CarResultScreen({super.key, required this.score});

  @override
  _CarResultScreenState createState() => _CarResultScreenState();
}

class _CarResultScreenState extends State<CarResultScreen> {
  int highestScore = 0;
  bool isNewHighestScore = false;

  @override
  void initState() {
    super.initState();
    fetchHighestScore(); // Fetch the current highest score when the screen is initialized
  }

  Future<void> fetchHighestScore() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      final firestore = FirebaseFirestore.instance;
      const String gameName = "car_game"; // Game name for car game

      final gameDoc = firestore
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc(gameName);

      final gameData = await gameDoc.get();

      if (gameData.exists) {
        setState(() {
          highestScore = gameData['highestScore'] ?? 0;
        });
      }
    } catch (e) {
      print("Error fetching highest score: $e");
    }
  }

  Future<void> saveGameData(int score) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      final firestore = FirebaseFirestore.instance;
      const String gameName = "car_game"; // Game name for car game

      final gameDoc = firestore
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc(gameName);

      final gameData = await gameDoc.get();

      if (gameData.exists) {
        List<int> lastScores = List<int>.from(gameData['lastScores'] ?? []);
        int currentHighestScore = gameData['highestScore'] ?? 0;

        // Check if the new score is higher than the current highest score
        if (score > currentHighestScore) {
          currentHighestScore = score;
          isNewHighestScore = true; // Set flag for new highest score
        }

        lastScores.add(score);
        if (lastScores.length > 5) {
          lastScores = lastScores.sublist(lastScores.length - 5);
        }

        await gameDoc.update({
          'highestScore': currentHighestScore,
          'lastScores': lastScores,
          'lastPlayed': FieldValue.serverTimestamp(),
        });

        // Update the highest score in the UI
        setState(() {
          highestScore = currentHighestScore;
        });

        // Show congratulatory message when a new highest score is achieved
        if (isNewHighestScore) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Congratulations! New Highest Score!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await gameDoc.set({
          'highestScore': score,
          'lastScores': [score],
          'lastPlayed': FieldValue.serverTimestamp(),
        });

        setState(() {
          highestScore = score;
        });
      }
    } catch (e) {
      print("Error saving game data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFAF7),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 100, color: Colors.yellow),
                const SizedBox(height: 16),
                const Text(
                  "Game Over!",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 16),
                Text(
                  "Your Score: ${widget.score}",
                  style: const TextStyle(fontSize: 24, color: Colors.red),
                ),
                const SizedBox(height: 16),
                Text(
                  "Highest Score: $highestScore",
                  style: const TextStyle(fontSize: 24, color: Colors.green),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    saveGameData(widget
                        .score); // Save the score and check if it’s a new high score
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => KidCarGame()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Restart",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    saveGameData(widget
                        .score); // Save the score and check if it’s a new high score
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Exit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
