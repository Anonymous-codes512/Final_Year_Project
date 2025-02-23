import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../games_page.dart';

class ResultScreenShape extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultScreenShape(
      {super.key, required this.score, required this.totalQuestions});

  @override
  _ResultScreenShapeState createState() => _ResultScreenShapeState();
}

class _ResultScreenShapeState extends State<ResultScreenShape> {
  int highScore = 0;
  String highScoreMessage = '';
  bool isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _getHighScore();
  }

  Future<void> _getHighScore() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('kids_data')
        .doc('games')
        .collection('game_scores')
        .doc('shape_game')
        .get();

    if (snapshot.exists) {
      int storedHighScore = snapshot['highestScore'] ?? 0;
      setState(() {
        highScore = storedHighScore;
      });

      if (widget.score > storedHighScore) {
        _updateScores(widget.score);
        setState(() {
          highScore = widget.score;
          highScoreMessage = 'New High Score!';
          isNewHighScore = true;
        });
      }
    }
  }

  Future<void> _updateScores(int newScore) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentReference gameDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('kids_data')
        .doc('games')
        .collection('game_scores')
        .doc('shape_game');

    DocumentSnapshot snapshot = await gameDoc.get();

    List<int> latestScores = [];
    if (snapshot.exists) {
      latestScores = List<int>.from(snapshot['latestScores'] ?? []);
      latestScores.add(newScore);
      if (latestScores.length > 5) {
        latestScores.removeAt(0);
      }

      await gameDoc.set({
        'highestScore': newScore,
        'latestScores': latestScores,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } else {
      await gameDoc.set({
        'highestScore': newScore,
        'latestScores': [newScore],
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        backgroundColor: const Color(0xFF3B9E9F),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFc2e9fb), Color(0xFFa1c4fd)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Score: ${widget.score} / ${widget.totalQuestions}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'High Score: $highScore',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: isNewHighScore ? Colors.redAccent : Colors.blueAccent,
                ),
              ),
              if (isNewHighScore)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    highScoreMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NumbersPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Exit',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ResultScreenShape extends StatefulWidget {
  final int score;
  final int totalQuestions;

  ResultScreenShape({required this.score, required this.totalQuestions});

  @override
  _ResultScreenShapeState createState() => _ResultScreenShapeState();
}
class _ResultScreenShapeState extends State<ResultScreenShape> {
  int highScore = 0;
  String highScoreMessage = '';
  bool isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _getHighScore();
  }

  Future<void> _getHighScore() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc('shape_game')
          .get();

      if (snapshot.exists) {
        int storedHighScore = snapshot['highestScore'] ?? 0;
        setState(() {
          highScore = storedHighScore;
        });

        // Check if the current score is a new high score
        if (widget.score > storedHighScore) {
          _updateScores(widget.score);
          setState(() {
            highScore = widget.score;
            highScoreMessage = 'New High Score!';
            isNewHighScore = true;
          });
        }
      }
    }
  }

  Future<void> _updateScores(int newScore) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentReference gameDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc('shape_game');

      DocumentSnapshot snapshot = await gameDoc.get();

      List<int> latestScores = [];
      if (snapshot.exists) {
        // Retrieve the latest 5 scores from Firestore
        latestScores = List<int>.from(snapshot['latestScores'] ?? []);

        // Add the new score to the list
        latestScores.add(newScore);

        // Keep only the latest 5 scores
        if (latestScores.length > 5) {
          latestScores.removeAt(0); // Remove the oldest score
        }

        // Update the document with new highest score and latest scores
        await gameDoc.set({
          'highestScore': newScore,
          'latestScores': latestScores,
          'lastUpdated': FieldValue.serverTimestamp(), // Add a timestamp of the update
        });
      } else {
        // If no previous scores, create a new entry with the current score
        await gameDoc.set({
          'highestScore': newScore,
          'latestScores': [newScore],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Results'),
        backgroundColor: Color(0xFF1572A1),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDEEDF0), Color(0xFF9AD0EC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: ${widget.score} / ${widget.totalQuestions}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'High Score: $highScore',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isNewHighScore ? Colors.red : Colors.purple,
              ),
            ),
            if (isNewHighScore)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  highScoreMessage,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the main game
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Play Again',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

