import 'package:flutter/material.dart';

class MultiplicationQuizPage extends StatefulWidget {
  const MultiplicationQuizPage({super.key});

  @override
  _MultiplicationQuizPageState createState() => _MultiplicationQuizPageState();
}

class _MultiplicationQuizPageState extends State<MultiplicationQuizPage> {
  int _currentIndex = 0;
  int _correctAnswers = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '2 × 4 = ?',
      'options': ['8', '6', '12', '10'],
      'answer': '8'
    },
    {
      'question': '1 × 1 = ?',
      'options': ['1', '2', '3', '4'],
      'answer': '1'
    },
    {
      'question': '_ × 3 = 9',
      'options': ['3', '6', '9', '12'],
      'answer': '3'
    },
    {
      'question': '9 × __ = 81',
      'options': ['9', '8', '10', '7'],
      'answer': '9'
    },
    {
      'question': '7 × __ = 56',
      'options': ['8', '7', '9', '6'],
      'answer': '8'
    },
    {
      'question': '__ × 8 = 64',
      'options': ['7', '6', '8', '9'],
      'answer': '8'
    },
    {
      'question': '__ × 6 = 48',
      'options': ['8', '9', '7', '6'],
      'answer': '8'
    },
    {
      'question': '11 × __ = 77',
      'options': ['7', '8', '6', '5'],
      'answer': '7'
    },
    {
      'question': '6 × __ = 36',
      'options': ['6', '5', '7', '8'],
      'answer': '6'
    },
    {
      'question': '8 × __ = 64',
      'options': ['8', '7', '9', '6'],
      'answer': '8'
    },
    {
      'question': '__ × 5 = 25',
      'options': ['5', '6', '4', '7'],
      'answer': '5'
    },
    {
      'question': '__ × 7 = 42',
      'options': ['6', '7', '8', '5'],
      'answer': '6'
    },
  ];

  void _answerQuestion(String option) {
    if (option == questions[_currentIndex]['answer']) {
      _correctAnswers++;
    }

    setState(() {
      if (_currentIndex < questions.length - 1) {
        _currentIndex++;
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
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
                    color: Colors.teal,
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
                  "Your score is $_correctAnswers out of ${questions.length}.",
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
                  '${((_correctAnswers / questions.length) * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _correctAnswers >= (questions.length / 2)
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
                          _correctAnswers = 0;
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
                      child: const Text("Restart",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route
                            .isFirst); // This will return to the first screen (level selection screen)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Text("Exit",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
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
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.85; // 85% of screen width

    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        title: const Text(
          'Multiplication Quiz',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The Memory and Recall Text in White Container
            Container(
              width: containerWidth,
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Memory and Recall Tests\nSection 1: Multiplication Tables',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    questions[_currentIndex]['question'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Options in White Containers
            ...questions[_currentIndex]['options'].map<Widget>((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  width: containerWidth,
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // button color
                      foregroundColor: Colors.teal, // text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 36),
                      elevation: 10,
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
