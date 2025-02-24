import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final int level;
  const QuizScreen({super.key, required this.level});

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
    {
      "question":
          "Do you find it difficult to do mental math and find yourself giving incorrect change or calculating a wildly inaccurate tip?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question":
          "Do you have trouble learning athletic movements, dance steps, or anything that requires you to move your body in a certain sequence?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question":
          "Do you forget phone numbers or addresses, even just a few moments after they were said to you?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question":
          "Do you skip numbers or read a few of them backward when reading a long list?",
      "option1": "Yes",
      "option2": "No"
    },
    {
      "question":
          "Do you run out of time when completing tasks on deadline, or find that much more time has passed than you had originally thought?",
      "option1": "Yes",
      "option2": "No"
    },
  ];

  int _currentIndex = 0;
  int _score = 0;

  // Get current user ID
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _saveScoreToFirestore() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users') // Root collection for users
            .doc(user.uid) // User document ID
            .collection('kids_data') // Collection for kids' data
            .doc('quiz') // Specific document for quiz data
            .collection('quiz_scores') // Collection for quiz scores
            .doc('level ${widget.level}') // Document for specific level
            .set({
          'score': _score,
          'level': widget.level,
          'timestamp': FieldValue.serverTimestamp(), // Add timestamp
        });

        print("Score saved successfully to Firestore.");
      } catch (e) {
        print("Error saving score to Firestore: $e");
      }
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
    _saveScoreToFirestore(); // Save score when the quiz ends
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
                // Header Text
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

                // Result Text
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

                // Action Buttons
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
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white), // Red text color
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route
                            .isFirst); // This will pop back to the first screen
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
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white), // Red text color
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
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Set the back arrow color to white
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: const Text(
                  "Yes",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _answerQuestion('No'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: const Text(
                  "No",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
