import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/game_screen.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/kids_level_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class QuizResultScreen extends StatefulWidget {
  final int totalQuestions;
  final int firstTryCorrect;
  final int questionsWithMistakes;
  final int totalWrongAttempts;
  final int score;
  final String level; // "easy", "medium", "hard", "advance"
  final Color themeColor;

  const QuizResultScreen({
    super.key,
    required this.totalQuestions,
    required this.firstTryCorrect,
    required this.questionsWithMistakes,
    required this.totalWrongAttempts,
    required this.score,
    required this.level,
    required this.themeColor,
  });

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late ConfettiController _confettiController;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // Start progress animation. Completion is calculated as the percentage
    // of questions answered (first try or with mistakes)
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        progress = (widget.firstTryCorrect + widget.questionsWithMistakes) /
            widget.totalQuestions;
      });

      if (widget.firstTryCorrect == widget.totalQuestions) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // Save result data to Firestore based on game level.
  Future<void> saveResultData() async {
    try {
      // Get the child's UID.
      String? childId = FirebaseAuth.instance.currentUser?.uid;
      if (childId == null) {
        print("No child id found");
        return;
      }

      String gameName = "additionGame";
      String levelSubCollection = widget.level.toLowerCase();

      // Build the Firestore path:
      // /users/{childId}/games/{gameName}/{levelSubCollection}/scores
      DocumentReference gameDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(childId)
          .collection('games')
          .doc(gameName)
          .collection(levelSubCollection)
          .doc('scores');

      print("Saving result data to: ${gameDoc.path}");

      // Retrieve existing game data if any.
      DocumentSnapshot docSnapshot = await gameDoc.get();
      List<Map<String, dynamic>> previousScores = [];
      int highScore = 0;

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        previousScores = List<Map<String, dynamic>>.from(data['scores'] ?? []);
        highScore = data['highScore'] ?? 0;
      }

      // Update high score if current score is higher.
      if (widget.score > highScore) {
        highScore = widget.score;
      }

      double maxScore = widget.totalQuestions *
          10; // assuming each question's max score is 10
      double percentage =
          widget.totalQuestions > 0 ? (widget.score / maxScore * 100) : 0.0;
      String percentageStr = percentage.toStringAsFixed(2);

      Map<String, dynamic> resultData = {
        'firstTryCorrect': widget.firstTryCorrect,
        'questionsWithMistakes': widget.questionsWithMistakes,
        'totalWrongAttempts': widget.totalWrongAttempts,
        'totalQuestions': widget.totalQuestions,
        'score': widget.score,
        'percentage': percentageStr,
        'level': widget.level,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      };

      // Prepend the new result data.
      previousScores.insert(0, resultData);
      if (previousScores.length > 5) {
        previousScores = previousScores.sublist(0, 5);
      }

      // Save the updated scores and high score.
      await gameDoc.set({
        'scores': previousScores,
        'highScore': highScore,
      });

      print("Game data saved successfully");
    } catch (e) {
      print("Error saving game data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving game data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], // Soft blue for kids
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              colors: const [
                Colors.yellow,
                Colors.green,
                Colors.pink,
                Colors.orange
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Score Progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(seconds: 2),
                          tween: Tween(begin: 0.0, end: progress),
                          builder: (context, value, child) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 10,
                              backgroundColor: Colors.blue[200],
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.blue),
                            );
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Text("Your Score",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900])),
                          Text("${widget.score}",
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800])),
                          Text("Points",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blue[900])),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Summary Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[300],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            spreadRadius: 1)
                      ],
                    ),
                    child: Column(
                      children: [
                        _summaryRow("Completion",
                            "${(progress * 100).toInt()}%", Colors.yellow),
                        _summaryRow("Total Questions",
                            "${widget.totalQuestions}", Colors.white),
                        _summaryRow("First Try Correct",
                            "${widget.firstTryCorrect}", Colors.green),
                        _summaryRow("With Mistakes",
                            "${widget.questionsWithMistakes}", Colors.orange),
                        _summaryRow("Total Wrong Attempts",
                            "${widget.totalWrongAttempts}", Colors.red),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Bottom Buttons: "Select Level" and "Try Again"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionButton(Icons.home, "Select Level", Colors.orange,
                          () async {
                        await saveResultData();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KidsLevelScreen()),
                          (route) => false,
                        );
                      }),
                      const SizedBox(width: 20),
                      _actionButton(Icons.refresh, "Try Again", Colors.blue,
                          () async {
                        await saveResultData();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(
                              level: widget.level,
                              themeColor: widget.themeColor,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Summary row with colorful indicators.
  Widget _summaryRow(String title, String value, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: dotColor, size: 10),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Fun button style for kids.
  Widget _actionButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      children: [
        FloatingActionButton(
          backgroundColor: color,
          onPressed: onTap,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
