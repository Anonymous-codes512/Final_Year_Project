import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Quiz_Screen2 extends StatefulWidget {
  final int level;
  const Quiz_Screen2({super.key, required this.level});

  @override
  _QuizScreen2State createState() => _QuizScreen2State();
}

class _QuizScreen2State extends State<Quiz_Screen2> {
  final List<Map<String, dynamic>> questions = [
    {
      "question":
          "Emily and her friends are going on a camping trip. They have a tent that requires a rectangular area of 10 feet by 12 feet. They need to buy a tarp to place under the tent to keep it dry. The store sells tarps in square feet. How many square feet of tarp do they need to buy to cover the entire area under the tent?",
      "options": [
        "110 square feet",
        "120 square feet",
        "130 square feet",
        "140 square feet"
      ],
      "answer": "120 square feet"
    },
    {
      "question":
          "Sarah is helping her school organize a bake sale. She decides to make cookies and sell them in packs. Each pack contains 6 cookies. If she has already baked 48 cookies, how many packs of cookies can she make? Additionally, if each pack is sold for \$3, how much money will she make if she sells all the packs?",
      "options": [
        "6 packs, \$18",
        "7 packs, \$21",
        "8 packs, \$24",
        "9 packs, \$27"
      ],
      "answer": "8 packs, \$24"
    },
    {
      "question":
          "John and his family are going on a road trip. They plan to travel a total of 350 miles to reach their destination. If they drive at an average speed of 50 miles per hour, how long will it take them to reach their destination? Assume they drive without any stops.",
      "options": ["5 hours", "6 hours", "7 hours", "8 hours"],
      "answer": "7 hours"
    },
    {
      "question":
          "Maria wants to plant a flower garden in her backyard. She has a rectangular plot that is 15 feet long and 8 feet wide. She wants to create a border around the garden using decorative stones. If each stone covers 1 foot of length, how many stones will Maria need to create a border around the entire garden?",
      "options": ["40 stones", "46 stones", "50 stones", "54 stones"],
      "answer": "46 stones"
    },
    {
      "question":
          "Alex is planning a birthday party and wants to order pizzas. Each pizza is cut into 8 slices. If Alex invites 10 friends to the party and expects each person to eat 3 slices of pizza, including himself, how many pizzas should he order to ensure everyone has enough to eat?",
      "options": ["4 pizzas", "5 pizzas", "6 pizzas", "7 pizzas"],
      "answer": "5 pizzas"
    },
    {
      "question":
          "Lucy goes to the bookstore to buy some new books. She finds that each book costs \$12. She has a gift card worth \$100. After buying the books, she wants to have at least \$20 left on her gift card. What is the maximum number of books Lucy can buy without spending all the money on her gift card?",
      "options": ["5 books", "6 books", "7 books", "8 books"],
      "answer": "6 books"
    },
    {
      "question":
          "David works on a farm where they harvest apples. Each basket can hold 25 apples. If David picks 300 apples in one day, how many baskets does he need to hold all the apples? Additionally, if each basket sells for \$10, how much will the total harvest be worth?",
      "options": [
        "10 baskets, \$100",
        "11 baskets, \$110",
        "12 baskets, \$120",
        "13 baskets, \$130"
      ],
      "answer": "12 baskets, \$120"
    },
    {
      "question":
          "Rachel is hosting a pool party and needs to fill the pool with water. The pool has a volume of 500 cubic feet. The water hose she is using can fill the pool at a rate of 10 cubic feet per minute. How long will it take to fill the entire pool?",
      "options": ["40 minutes", "45 minutes", "50 minutes", "55 minutes"],
      "answer": "50 minutes"
    },
    {
      "question":
          "Kevin goes shopping for clothes. He buys 3 shirts that each cost \$15, 2 pairs of pants that each cost \$25, and 1 jacket that costs \$40. If Kevin has a budget of \$120, how much money will he have left after making his purchases?",
      "options": ["\$0", "\$5", "\$10", "\$15"],
      "answer": "\$0"
    },
    {
      "question":
          "Emma and her classmates are working on a school project that requires creating a model of a building. The base of the building is a rectangle that measures 10 inches by 8 inches. They want to cover the base with square tiles that each measure 2 inches on each side. How many tiles will they need to cover the entire base?",
      "options": ["20 tiles", "30 tiles", "40 tiles", "50 tiles"],
      "answer": "20 tiles"
    }
    // Add other questions here...
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

  void _showResult() {
    _saveScoreToFirestore(); // Save score when the result is shown

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
                    color: Colors.blueAccent,
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
                        color: Colors.green,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        "Restart",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route
                            .isFirst); // This will pop back to the first screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
        decoration: const BoxDecoration(
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
