import 'package:flutter/material.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/Game_Result_Screen.dart';
import 'dart:math';
import 'dart:async';

class GameScreen extends StatefulWidget {
  final String level;
  final Color themeColor;
  final String userId;
  final String parentEmail;

  const GameScreen(
      {super.key,
      required this.level,
      required this.themeColor,
      required this.userId,
      required this.parentEmail});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  late int num1, num2;
  late String operator;
  final TextEditingController _answerController = TextEditingController();

  // Feedback variables
  String _feedback = '';
  Color _feedbackColor = Colors.black;

  // Timer variables
  late int _timeLeft;
  Timer? _timer;

  // Score & result tracking
  int _score = 0;
  final int _totalQuestions = 30;
  int _questionCount = 0; // questions answered correctly so far

  // For result summary breakdown:
  int _firstTryCorrect = 0; // answered correctly on first attempt
  int _questionsWithMistakes =
      0; // questions that required at least one wrong attempt
  int _totalWrongAttempts =
      0; // total number of wrong attempts (for penalty or stats)

  // For current question
  bool _firstAttempt = true;
  int _wrongAttemptsCurrentQuestion = 0;

  // Progress
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setTimeBasedOnLevel();
    _generateNewProblem();
    _startTimer();
  }

  void _setTimeBasedOnLevel() {
    switch (widget.level) {
      case 'Easy':
        _timeLeft = 180;
        break;
      case 'Medium':
        _timeLeft = 120;
        break;
      case 'Hard':
        _timeLeft = 60;
        break;
      case 'Advanced':
        _timeLeft = 30;
        break;
      default:
        _timeLeft = 180;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        _showGameOverDialog();
      }
    });
  }

  // Shows the result summary dialog.
  void _showGameOverDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuizResultScreen(
        totalQuestions: _totalQuestions,
        firstTryCorrect: _firstTryCorrect,
        questionsWithMistakes: _questionsWithMistakes,
        totalWrongAttempts: _totalWrongAttempts,
        score: _score,
        level: widget.level,
        userId: widget.userId,
        parentEmail: widget.parentEmail,
        themeColor: widget.themeColor,
      ),
    );
  }

  // Generates a new math problem and resets per-question variables.
  void _generateNewProblem() {
    if (_questionCount >= _totalQuestions) return;
    setState(() {
      // Reset current question flags
      _firstAttempt = true;
      _wrongAttemptsCurrentQuestion = 0;
      _feedback = '';
      _feedbackColor = Colors.black;
      _answerController.clear();

      // Generate problem: For later questions, use only multiplication/division.
      if (_questionCount >= 20) {
        operator = ['×', '÷'][_random.nextInt(2)];
        num1 = _random.nextInt(20) + 10;
        do {
          num2 = _random.nextInt(10) + 1;
        } while (operator == '÷' && num1 % num2 != 0);
      } else {
        operator = ['+', '-', '×', '÷'][_random.nextInt(4)];
        do {
          num1 = _random.nextInt(10) + 1;
          num2 = _random.nextInt(10) + 1;
          if (operator == '÷') {
            while (num2 == 0 || num1 % num2 != 0) {
              num1 = _random.nextInt(10) + 1;
              num2 = _random.nextInt(10) + 1;
            }
          }
          if (operator == '-') {
            if (num1 < num2) {
              int temp = num1;
              num1 = num2;
              num2 = temp;
            }
          }
        } while (operator == '÷' && (num1 % num2 != 0 || num1 < num2));
      }
    });
  }

  // Computes the correct answer.
  int _calculateCorrectAnswer() {
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '×':
        return num1 * num2;
      case '÷':
        return num1 ~/ num2;
      default:
        return 0;
    }
  }

  // Called when user presses the Submit button.
  void _checkAnswer() {
    if (_answerController.text.isEmpty) return;

    int correctAnswer = _calculateCorrectAnswer();
    int? userAnswer = int.tryParse(_answerController.text);

    if (userAnswer == null) return;

    if (userAnswer == correctAnswer) {
      // If it was the first attempt, count as first try correct.
      if (_firstAttempt) {
        _firstTryCorrect++;
      } else {
        _questionsWithMistakes++;
      }
      // Update score: +10 for correct minus penalty for any wrong attempts.
      _score += 10 - (_wrongAttemptsCurrentQuestion * 5);

      // Mark the question as complete.
      setState(() {
        _questionCount++;
        _progress = _questionCount / _totalQuestions;
      });

      _feedback = '🎉 Correct! 🎉';
      _feedbackColor = Colors.green;

      // Add total wrong attempts for summary.
      _totalWrongAttempts += _wrongAttemptsCurrentQuestion;

      if (_questionCount >= _totalQuestions) {
        Future.delayed(const Duration(milliseconds: 500), _showGameOverDialog);
      } else {
        Future.delayed(const Duration(milliseconds: 500), _generateNewProblem);
      }
    } else {
      // Wrong answer: update the flag if this is the first wrong attempt.
      if (_firstAttempt) {
        _firstAttempt = false;
      }
      _wrongAttemptsCurrentQuestion++;
      _feedback = '❌ Try again! ❌';
      _feedbackColor = Colors.red;
      // Optionally, you can also subtract penalty for every wrong attempt here:
      setState(() {
        _score -= 5;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Display the current question number as _questionCount + 1 (1-indexed)
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.themeColor.withOpacity(0.7), widget.themeColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Timer and Score Section
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.themeColor,
                      widget.themeColor.withOpacity(0.7)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(200),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(2, 5),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/timer.gif',
                      height: 75,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_timeLeft ~/ 60}:${(_timeLeft % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFD700),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Score: $_score',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Progress and Question Number
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: _progress,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      backgroundColor: Colors.white,
                      color: widget.themeColor.withGreen(150),
                      minHeight: 10,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Question ${_questionCount + 1} of $_totalQuestions',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Solve the equation',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Equation & Answer Input
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(150),
                    bottomLeft: Radius.circular(150),
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '$num1 $operator $num2',
                      style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                    const Divider(
                        thickness: 2, color: Colors.black, height: 30),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _answerController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.purple.shade50,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: _checkAnswer,
                      child: const Text('Submit'),
                    ),
                    Text(
                      _feedback,
                      style: TextStyle(fontSize: 18, color: _feedbackColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
