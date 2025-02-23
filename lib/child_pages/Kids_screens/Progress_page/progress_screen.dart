import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressGraphScreen extends StatelessWidget {
  final String userId;

  const ProgressGraphScreen({super.key, required this.userId});

  // Fetch game scores from Firestore
  Future<Map<String, List<int>>> fetchGameScores(String userId) async {
    final gamesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('kids_data')
        .doc('games')
        .collection('game_scores');

    final querySnapshot = await gamesCollection.get();

    // Map to store scores for each game
    Map<String, List<int>> gameScores = {};

    for (var doc in querySnapshot.docs) {
      if (doc.data().containsKey('scores')) {
        // Extract the 'scores' field which is a list of objects
        List<dynamic> scoresData = doc['scores'];
        List<int> scores =
            scoresData.map((entry) => entry['score'] as int).toList();
        gameScores[doc.id] = scores; // Add game scores to the map
      }
    }

    return gameScores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Graph'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFD1C4E9)
            ], // Soft purple gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, List<int>>>(
          // Fetch game scores data
          future: fetchGameScores(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(), // Show a loading indicator
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No scores found for this user.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            final gameScores =
                snapshot.data!; // Get the game scores from the snapshot
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: gameScores.keys.length,
              itemBuilder: (context, index) {
                final gameName = gameScores.keys.elementAt(index);
                final scores = gameScores[gameName]!;

                if (scores.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No scores available for $gameName.',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Display the graph for each game
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gameName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      interval: 10,
                                      getTitlesWidget: (value, meta) => Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) => Text(
                                        'Q${value.toInt()}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border:
                                      Border.all(color: Colors.purpleAccent),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: scores.asMap().entries.map((e) {
                                      return FlSpot(e.key.toDouble() + 1,
                                          e.value.toDouble());
                                    }).toList(),
                                    isCurved: true,
                                    color: Colors.purpleAccent,
                                    barWidth: 3,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.purple.withOpacity(0.3),
                                    ),
                                    dotData: const FlDotData(show: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
