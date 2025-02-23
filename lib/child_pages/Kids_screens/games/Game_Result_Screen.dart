import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/Kids_Level_Screen.dart';

class QuizResultScreen extends StatefulWidget {
  final int totalQuestions;
  final int firstTryCorrect;
  final int questionsWithMistakes;
  final int totalWrongAttempts;
  final int score;
  final String level;
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
    // of questions answered (whether first try or with mistakes)
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
                          () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KidsLevelScreen()),
                          (route) => false,
                        );
                      }),
                      const SizedBox(width: 20),
                      _actionButton(Icons.refresh, "Try Again", Colors.blue,
                          () {
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

  // Summary row with colorful indicators
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

  // Fun button style for kids
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
