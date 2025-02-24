import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen(
      {super.key, required this.score, required this.totalQuestions});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  final bool _isUpdating = false;
  List<Map<String, dynamic>> scores = [];
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    loadGameData("additionGame");
  }

  Future<void> loadGameData(String gameName) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference gameDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc(gameName);

      DocumentSnapshot docSnapshot = await gameDoc.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        scores = List<Map<String, dynamic>>.from(data['scores'] ?? []);
        highScore = data['highScore'] ?? 0;

        setState(() {});
      }
    } catch (e) {
      print("Error loading game data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading game data: $e')),
      );
    }
  }

  Future<void> saveGameData(String gameName, int score) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference gameDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_data')
          .doc('games')
          .collection('game_scores')
          .doc(gameName);

      // Check and update the high score.
      bool isNewHighScore = false;
      if (score > highScore) {
        highScore = score;
        isNewHighScore = true;
      }

      // Compute the percentage of correct answers.
      double percentage = widget.totalQuestions > 0
          ? (widget.score / widget.totalQuestions * 100)
          : 0.0;
      String percentageStr = percentage.toStringAsFixed(2);

      // Insert a new result map with additional fields.
      scores.insert(0, {
        'score': widget.score,
        'totalQuestions': widget.totalQuestions,
        'percentage': percentageStr,
        'highScore': highScore,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Keep only the latest 5 results.
      if (scores.length > 5) {
        scores = scores.sublist(0, 5);
      }

      // Save the updated data to Firestore.
      await gameDoc.set({
        'scores': scores,
        'highScore': highScore,
      });

      if (isNewHighScore) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New High Score Achieved!')),
        );
      }

      setState(() {}); // Refresh UI.
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
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 30,
            spawnMinSpeed: 15,
            particleCount: 80,
            spawnMaxSpeed: 30,
            baseColor: Colors.lightBlueAccent,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[200]!, Colors.blue[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: _isUpdating
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Game Over!',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildScoreRow(
                              icon: Icons.question_mark,
                              label: 'Total Questions',
                              value: widget.totalQuestions.toString(),
                            ),
                            const SizedBox(height: 10),
                            _buildScoreRow(
                              icon: Icons.check_circle,
                              label: 'Correct Answers',
                              value: widget.score.toString(),
                            ),
                            const SizedBox(height: 10),
                            _buildScoreRow(
                              icon: Icons.star,
                              label: 'Score',
                              value:
                                  '${(widget.score / widget.totalQuestions * 100).toStringAsFixed(2)}%',
                            ),
                            const SizedBox(height: 10),
                            _buildScoreRow(
                              icon: Icons.leaderboard,
                              label: 'High Score',
                              value: highScore.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          String gameName = "additionGame";
                          await saveGameData(gameName, widget.score);

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.deepPurple,
                          shadowColor: Colors.purpleAccent,
                        ),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
