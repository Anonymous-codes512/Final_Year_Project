import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizScreen2 extends StatefulWidget {
  final int level;
  final String uid;
  final String parentEmail;
  const QuizScreen2(
      {super.key,
      required this.level,
      required this.uid,
      required this.parentEmail});

  @override
  _QuizScreen2State createState() => _QuizScreen2State();
}

class _QuizScreen2State extends State<QuizScreen2> {
  final List<Map<String, dynamic>> questions = [
    {
      "question": "Emily and her friends are going on a camping trip...",
      "options": [
        "110 square feet",
        "120 square feet",
        "130 square feet",
        "140 square feet"
      ],
      "answer": "120 square feet"
    },
    {
      "question": "Sarah is helping her school organize a bake sale...",
      "options": [
        "6 packs, \$18",
        "7 packs, \$21",
        "8 packs, \$24",
        "9 packs, \$27"
      ],
      "answer": "8 packs, \$24"
    },
    {
      "question": "John and his family are going on a road trip...",
      "options": ["5 hours", "6 hours", "7 hours", "8 hours"],
      "answer": "7 hours"
    },
  ];

  int _currentIndex = 0;
  int _score = 0;

  void _answerQuestion(String answer) {
    if (answer == questions[_currentIndex]['answer']) {
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

  Future<void> _saveScoreToFirestore() async {
    try {
      String parentEmail =
          widget.parentEmail.toLowerCase().trim(); // Parent document ID
      String childId = widget.uid; // Child ID inside children array
      String gameName = "quiz"; // Game name
      String levelKey = "level_${widget.level}"; // Store level dynamically

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

      List<dynamic> children = parentData["children"] ?? [];

      bool childFound = false;

      // Loop through children to find the correct childId
      for (var i = 0; i < children.length; i++) {
        if (children[i]["childId"] == childId) {
          childFound = true;

          // Ensure gameData exists
          if (children[i]["gameData"] == null) {
            children[i]["gameData"] = {};
          }

          // Ensure quiz data exists inside gameData
          if (children[i]["gameData"][gameName] == null) {
            children[i]["gameData"][gameName] = {};
          }

          // Ensure level data exists inside quiz
          if (children[i]["gameData"][gameName][levelKey] == null) {
            children[i]["gameData"][gameName][levelKey] = [];
          }

          String formattedDate =
              DateFormat('dd-MM-yyyy').format(DateTime.now());

          // Create a new score entry with formatted date
          Map<String, dynamic> scoreEntry = {
            "score": _score,
            "date": formattedDate, // Store only DD-MM-YYYY
          };

          children[i]["gameData"][gameName][levelKey].add(scoreEntry);
          break;
        }
      }

      if (!childFound) {
        print("🚨 Child ID $childId not found under parent $parentEmail.");
        return;
      }

      // Update Firestore with modified children list
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
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
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
        backgroundColor: Colors.blueAccent,
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
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
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
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    questions[_currentIndex]['question'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...questions[_currentIndex]['options'].map<Widget>((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
