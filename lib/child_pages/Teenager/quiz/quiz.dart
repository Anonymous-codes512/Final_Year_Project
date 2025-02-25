import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizScreen extends StatefulWidget {
  final int level;
  final String uid;
  final String parentEmail;
  const QuizScreen(
      {super.key,
      required this.level,
      required this.uid,
      required this.parentEmail});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, String>> questions = [
    {
      "question": "Do you have difficulty reading graphs or charts?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question":
          "Do you find it hard to stick to a budget or keep track of your finances?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question":
          "Do you have trouble estimating how long it will take you to get somewhere, even if you’ve made the trip before?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question": "Do you have trouble telling time on an analog clock?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question":
          "Do you forget math facts that everyone else seems to know, like times tables or common formulas?",
      "option1": "Yes",
      "option2": "No"
    },
  ];

  int _currentIndex = 0;
  int _score = 0;

  Future<void> _saveScoreToFirestore() async {
    try {
      String parentEmail =
          widget.parentEmail.toLowerCase().trim(); // Parent document ID
      String childId = widget.uid; // Child ID inside children array
      String gameName = "quiz"; // Game name
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

          // Ensure quiz data exists inside gameData
          if (children[i]["gameData"][gameName] == null) {
            print("🛠 Creating quiz field...");
            children[i]["gameData"][gameName] = {};
          }

          // Ensure level data exists inside quiz
          if (children[i]["gameData"][gameName][levelKey] == null) {
            print("🛠 Creating level field...");
            children[i]["gameData"][gameName][levelKey] = [];
          }

          // Format the date as "DD-MM-YYYY"
          String formattedDate =
              DateFormat('dd-MM-yyyy').format(DateTime.now());

          // Create a new score entry with formatted date
          Map<String, dynamic> scoreEntry = {
            "score": _score,
            "date": formattedDate, // Store only DD-MM-YYYY
          };

          print("📌 Score Entry: $scoreEntry");

          // Append new score with date
          children[i]["gameData"][gameName][levelKey].add(scoreEntry);

          print(
              "✅ Score $_score added to $levelKey with date $formattedDate for child $childId");

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
      print("⚠️ Error saving score to Firestore: $e");
    }
  }

  void _answerQuestion(String answer) {
    if (answer == "Yes") {
      setState(() {
        _score++;
      });
    }

    if (_currentIndex < questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    _saveScoreToFirestore();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade200, Colors.teal.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Test Result",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "Your score is $_score out of ${questions.length} for Level ${widget.level}.",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Score Percentage
                Text(
                  '${((_score / questions.length) * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _score >= (questions.length / 2)
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                          _score = 0;
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black,
                        elevation: 5,
                      ),
                      child: const Text(
                        "Restart",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black,
                        elevation: 5,
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Level ${widget.level}',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Card(
                  key: ValueKey<int>(_currentIndex),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      questions[_currentIndex]['question']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _answerQuestion('Yes'),
                child: const Text("Yes", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _answerQuestion('No'),
                child: const Text("No", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
