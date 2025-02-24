import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarResultScreen extends StatefulWidget {
  final int score;
  final String level; // Game Level

  const CarResultScreen({super.key, required this.score, required this.level});

  @override
  _CarResultScreenState createState() => _CarResultScreenState();
}

class _CarResultScreenState extends State<CarResultScreen> {
  int highestScore = 0;
  bool isNewHighestScore = false;

  @override
  void initState() {
    super.initState();
    fetchHighestScore();
  }

  Future<void> fetchHighestScore() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      final firestore = FirebaseFirestore.instance;

      // Firestore path: /users/{userId}/games/catch the ball/{level}/score
      final gameDoc = firestore
          .collection('users')
          .doc(userId)
          .collection('games')
          .doc('catch the ball')
          .collection(
              widget.level.toLowerCase()) // Subcollection for each level
          .doc('score');

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

      // Firestore path: /users/{userId}/games/catch the ball/{level}/score
      final gameDoc = firestore
          .collection('users')
          .doc(userId)
          .collection('games')
          .doc('catch the ball')
          .collection(
              widget.level.toLowerCase()) // Subcollection for each level
          .doc('score');

      final gameData = await gameDoc.get();
      List<int> lastScores = [];

      if (gameData.exists) {
        lastScores = List<int>.from(gameData['lastScores'] ?? []);
        int currentHighestScore = gameData['highestScore'] ?? 0;

        if (score > currentHighestScore) {
          currentHighestScore = score;
          isNewHighestScore = true;
        }

        lastScores.add(score);
        if (lastScores.length > 5) {
          lastScores.removeAt(0);
        }

        await gameDoc.set({
          'highestScore': currentHighestScore,
          'lastScores': lastScores,
          'lastPlayed': FieldValue.serverTimestamp(),
        });

        setState(() {
          highestScore = currentHighestScore;
        });

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
      // Gradient background for a modern look.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent,
              const Color.fromARGB(255, 111, 200, 241)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events,
                        size: 100, color: Colors.amber),
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
                      "Highest Score (${widget.level}): $highestScore",
                      style: const TextStyle(fontSize: 24, color: Colors.green),
                    ),
                    if (isNewHighestScore)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "New High Score!",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            saveGameData(widget.score);
                            Navigator.pop(context);
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
                        ElevatedButton(
                          onPressed: () {
                            saveGameData(widget.score);
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
