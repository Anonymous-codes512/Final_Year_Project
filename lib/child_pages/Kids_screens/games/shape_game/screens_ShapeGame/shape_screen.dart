import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/result_shape_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ShapeScreen extends StatefulWidget {
  final String userId;
  final String parentEmail;
  const ShapeScreen(
      {required this.userId, required this.parentEmail, super.key});

  @override
  _ShapeScreenState createState() => _ShapeScreenState();
}

class _ShapeScreenState extends State<ShapeScreen> {
  final List<String> shapes = [
    'Rectangle',
    'Circle',
    'Square',
    'Triangle',
    'Pentagon',
    'Quadrilateral',
    'Star',
    'Diamond',
    'Heart',
  ];

  final Map<String, String> shapeImages = {
    'Rectangle': 'assets/shapes/rectangle.png',
    'Circle': 'assets/shapes/circle.png',
    'Square': 'assets/shapes/square.png',
    'Triangle': 'assets/shapes/triangle.png',
    'Pentagon': 'assets/shapes/pentagon.png',
    'Quadrilateral': 'assets/shapes/quadrilateral.png',
    'Star': 'assets/shapes/star.png',
    'Diamond': 'assets/shapes/diamond.png',
    'Heart': 'assets/shapes/heart.png',
  };

  Random random = Random();
  int currentShapeIndex = 0;
  int questionCount = 0;
  int correctAnswers = 0;
  List<String> options = [];
  String? userId;
  bool isAnswerSelected = false;
  bool isAnswerCorrect = false;
  String feedbackMessage = '';
  final int totalQuestions = 8;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _generateNewShape();
  }

  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> _saveScoreToFirebase(int score) async {
    try {
      String parentEmail =
          widget.parentEmail.toLowerCase().trim(); // Parent document ID
      String childId = widget.userId; // Child ID inside children array
      String gameName = "shape_game"; // Game name
      String levelKey = "level_Easy"; // Store level dynamically

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

          // Ensure shape_game data exists inside gameData
          if (children[i]["gameData"][gameName] == null) {
            print("🛠 Creating shape_game field...");
            children[i]["gameData"][gameName] = {};
          }

          // Ensure level data exists inside shape_game
          if (children[i]["gameData"][gameName][levelKey] == null) {
            print("🛠 Creating level field...");
            children[i]["gameData"][gameName]
                [levelKey] = {"highestScore": 0, "scores": []};
          }

          // Get the current highest score
          int highestScore =
              children[i]["gameData"][gameName][levelKey]["highestScore"] ?? 0;

          // Update highest score if the new score is greater
          if (score > highestScore) {
            print("🎯 New highest score: $score (Previous: $highestScore)");
            children[i]["gameData"][gameName][levelKey]["highestScore"] = score;
          }

          // Format the date as "DD-MM-YYYY"
          String formattedDate =
              DateFormat('dd-MM-yyyy').format(DateTime.now());

          // Append new score entry with date
          Map<String, dynamic> scoreEntry = {
            "score": score,
            "date": formattedDate, // Store only DD-MM-YYYY
          };

          children[i]["gameData"][gameName][levelKey]["scores"].add(scoreEntry);

          print(
              "✅ Score $score added to $levelKey with date $formattedDate for child $childId");

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
    }
  }

  void _generateNewShape() async {
    if (questionCount < totalQuestions) {
      setState(() {
        currentShapeIndex = random.nextInt(shapes.length);
        options = [shapes[currentShapeIndex]];

        while (options.length < 3) {
          String incorrectShape = shapes[random.nextInt(shapes.length)];
          if (!options.contains(incorrectShape)) {
            options.add(incorrectShape);
          }
        }
        options.shuffle();
        isAnswerSelected = false; // Reset selection status
        isAnswerCorrect = false; // Reset answer correctness
        feedbackMessage = ''; // Clear feedback message
        questionCount++;
      });
    } else {
      // Save score and navigate to the result screen
      await _saveScoreToFirebase(correctAnswers);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreenShape(
            score: correctAnswers,
            totalQuestions: totalQuestions,
          ),
        ),
      );
    }
  }

  void _checkAnswer(String selectedShape) {
    setState(() {
      isAnswerSelected = true; // Answer is selected

      if (selectedShape == shapes[currentShapeIndex]) {
        correctAnswers++;
        isAnswerCorrect = true;
        feedbackMessage = 'Correct!';
      } else {
        isAnswerCorrect = false;
        feedbackMessage = 'Try Again!';
      }
    });

    // Generate a new shape after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewShape();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shape Recognition Game'),
        backgroundColor: const Color(0xFF1572A1),
      ),
      body: Container(
        width: double.infinity, // Ensures full screen width
        height: double.infinity, // Ensures full screen height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDEEDF0), Color(0xFF9AD0EC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Guess the Shape!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Image.asset(
              shapeImages[shapes[currentShapeIndex]]!,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // Display feedback (Correct or Try Again) after the user answers
            Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 24,
                color: isAnswerCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Display options as rectangular buttons in a row with consistent size
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: options
                  .map((option) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent, // Button color
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // No rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0), // Padding
                            elevation: 5, // Shadow for a raised look
                            minimumSize: const Size(
                                75, 50), // Smaller button size with same width
                          ),
                          onPressed: isAnswerSelected
                              ? null // Disable buttons after selection
                              : () => _checkAnswer(option),
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto', // A playful font
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
