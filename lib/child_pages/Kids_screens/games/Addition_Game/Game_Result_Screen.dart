import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/game_screen.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/kids_level_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final int totalQuestions;
  final int firstTryCorrect;
  final int questionsWithMistakes;
  final int totalWrongAttempts;
  final int score;
  final String level; // "easy", "medium", "hard", "advance"
  final String userId;
  final String parentEmail;
  final Color themeColor;

  const QuizResultScreen({
    super.key,
    required this.totalQuestions,
    required this.firstTryCorrect,
    required this.questionsWithMistakes,
    required this.totalWrongAttempts,
    required this.score,
    required this.level,
    required this.userId,
    required this.parentEmail,
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

    // Start progress animation
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

  /// **🔥 Save result data to Firestore based on Firestore Structure**
  Future<void> saveResultData() async {
    try {
      String parentEmail =
          widget.parentEmail.toLowerCase().trim(); // Parent document ID
      String childId = widget.userId; // Child ID inside children array
      String gameName = "additionGame"; // Game name
      String levelKey = "level_${widget.level}"; // Store level dynamically

      print("🔍 Fetching parent document for: $parentEmail");

      // Fetch parent document
      DocumentSnapshot parentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(parentEmail)
          .get();

      if (!parentDoc.exists) {
        print("🚨 Parent document not found: $parentEmail");
        return;
      }

      Map<String, dynamic> parentData =
          parentDoc.data() as Map<String, dynamic>;

      print("✅ Parent document found! Data: $parentData");

      List<dynamic> children = parentData["children"] ?? [];

      if (children.isEmpty) {
        print("🚨 No children found under parent: $parentEmail");
        return;
      }

      bool childFound = false;

      print("📌 Searching for childId: $childId in children list...");

      // Loop through children to find the correct childId
      for (var i = 0; i < children.length; i++) {
        print("🧐 Checking child: ${children[i]["childId"]}");

        if (children[i]["childId"] == childId) {
          childFound = true;
          print("✅ Child ID matched: $childId");

          // Ensure gameData exists
          if (children[i]["gameData"] == null) {
            print("🛠 Creating gameData field...");
            children[i]["gameData"] = {};
          }

          // Ensure additionGame data exists inside gameData
          if (children[i]["gameData"][gameName] == null) {
            print("🛠 Creating additionGame field...");
            children[i]["gameData"][gameName] = {};
          }

          // Ensure level data exists inside additionGame
          if (children[i]["gameData"][gameName][levelKey] == null) {
            print("🛠 Creating level field...");
            children[i]["gameData"][gameName][levelKey] = [];
          }

          String formattedDate =
              DateFormat('dd-MM-yyyy').format(DateTime.now());

          Map<String, dynamic> scoreEntry = {
            "score": widget.score,
            "timestamp": formattedDate,
          };

          // Append new score with timestamp
          children[i]["gameData"][gameName][levelKey].add(scoreEntry);
          print(
              "✅ Score ${widget.score} added to $levelKey for child $childId");

          break;
        }
      }

      if (!childFound) {
        print("🚨 Child ID $childId NOT found under parent $parentEmail.");
        return;
      }

      // Update Firestore with modified children list
      print("📤 Saving updated children data...");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(parentEmail)
          .update({
        "children": children,
      });

      print(
          "✅ Score saved successfully for child $childId in game $gameName (Level: $levelKey).");
    } catch (e) {
      print("⚠️ Error saving game data: $e");
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
                    ),
                    child: Column(
                      children: [
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
                              builder: (context) => KidsLevelScreen(
                                    userId: widget.userId,
                                    parentEmail: widget.parentEmail,
                                  )),
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
                              userId: widget.userId,
                              parentEmail: widget.parentEmail,
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

  Widget _summaryRow(String title, String value, Color dotColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
      ],
    );
  }

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
