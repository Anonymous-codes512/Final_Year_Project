import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsScreen extends StatefulWidget {
  final Map<String, dynamic> childData;

  const StatsScreen({super.key, required this.childData});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String? selectedGame;
  String? selectedLevel;
  List<String> gameNames = [];
  List<String> levelNames = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGames();
    });
  }

  void _initializeGames() {
    if (widget.childData.containsKey('gameData') &&
        widget.childData['gameData'] is Map<String, dynamic>) {
      setState(() {
        gameNames = widget.childData['gameData'].keys.toList();
      });
    }
  }

  void _onGameSelected(String? newGame) {
    setState(() {
      selectedGame = newGame;
      selectedLevel = null;
      var levelMap = widget.childData['gameData'][selectedGame];
      if (levelMap is Map<String, dynamic>) {
        levelNames = levelMap.keys.toList();
      } else {
        levelNames = [];
      }
    });
  }

  void _onLevelSelected(String? newLevel) {
    setState(() {
      selectedLevel = newLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.childData['name']}'s Game Scores",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFFFFFFFF))),
        centerTitle: true,
        backgroundColor: Color(0xFF332F46),
        iconTheme: IconThemeData(color: Color(0XFFFFFFFF)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF332F46), Color(0xFF48435F)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                  "Select Game", gameNames, selectedGame, _onGameSelected),
              SizedBox(height: 12),
              _buildDropdown(
                  "Select Level", levelNames, selectedLevel, _onLevelSelected),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: selectedGame != null && selectedLevel != null
                      ? _buildScoreChart(
                          widget.childData, selectedGame!, selectedLevel!)
                      : Center(
                          child: Text(
                            "Select a game and level to view scores",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12),
              if (selectedGame != null && selectedLevel != null)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Builder(
                    builder: (_) {
                      final scores = _getScores();
                      if (scores.isEmpty) {
                        return Text(
                          "No data found for this selection.",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        );
                      }

                      double avg = scores
                              .map((e) => (e['score'] ?? 0).toDouble())
                              .fold(0.0, (a, b) => a + b) /
                          scores.length;

                      double highest = scores
                          .map((e) => (e['score'] ?? 0).toDouble())
                          .reduce((a, b) => a > b ? a : b);

                      double lowest = scores
                          .map((e) => (e['score'] ?? 0).toDouble())
                          .reduce((a, b) => a < b ? a : b);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Summary for $selectedGame - $selectedLevel:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 6),
                          Text("📊 Average Score: ${avg.toStringAsFixed(1)}"),
                          Text("🏆 Highest Score: $highest"),
                          Text("📉 Lowest Score: $lowest"),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF))),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text("Choose"),
              items: items
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreChart(
      Map<String, dynamic> childData, String game, String level) {
    List<Map<String, dynamic>> scoresList = [];

    if (childData.containsKey('gameData') &&
        childData['gameData'] is Map &&
        childData['gameData'][game] is Map &&
        childData['gameData'][game].containsKey(level)) {
      var levelData = childData['gameData'][game][level];

      if (levelData is List) {
        scoresList = levelData
            .map((entry) => {
                  "date": entry["timestamp"] is Timestamp
                      ? (entry["timestamp"] as Timestamp).toDate()
                      : entry["timestamp"] ?? entry["date"] ?? "Unknown",
                  "score": entry["score"] ?? 0
                })
            .toList();
      } else if (levelData is Map) {
        if (levelData.containsKey("lastScores")) {
          scoresList = List<Map<String, dynamic>>.from(levelData["lastScores"]);
        } else if (levelData.containsKey("scores")) {
          scoresList = List<Map<String, dynamic>>.from(levelData["scores"]);
        } else if (levelData.containsKey("highestScore")) {
          scoresList = [
            {"date": "N/A", "score": levelData["highestScore"]}
          ];
        }
      }
    }

    if (scoresList.isEmpty) return _noDataMessage();

    scoresList.sort((a, b) {
      final aDate = a['date'];
      final bDate = b['date'];
      if (aDate is DateTime && bDate is DateTime) {
        return aDate.compareTo(bDate);
      }
      return 0;
    });

    List<FlSpot> spots = [];
    List<String> dateLabels = [];

    for (int i = 0; i < scoresList.length; i++) {
      final score = scoresList[i]['score'] ?? 0;
      final date = scoresList[i]['date'];
      String formattedDate =
          date is DateTime ? DateFormat('dd/MM').format(date) : date.toString();
      spots.add(FlSpot(i.toDouble(), score.toDouble()));
      dateLabels.add(formattedDate);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final chartWidth = scoresList.length * 90;
    final minWidth = screenWidth * 0.9;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: (chartWidth < minWidth ? minWidth : chartWidth).toDouble(),
          height: 500,
          child: LineChart(
            LineChartData(
              minY: (spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 10)
                  .floorToDouble(),
              maxY:
                  ((spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) / 25)
                              .ceil() +
                          1) *
                      25,
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.deepPurple,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                      show: true, color: Colors.deepPurple.withOpacity(0.2)),
                  barWidth: 3,
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 25,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < dateLabels.length) {
                        return SideTitleWidget(
                          fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                          space: 6,
                          meta: meta,
                          child: Text(
                            dateLabels[index],
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getScores() {
    List<Map<String, dynamic>> scoresList = [];

    if (widget.childData.containsKey('gameData') &&
        widget.childData['gameData'] is Map &&
        widget.childData['gameData'][selectedGame] is Map &&
        widget.childData['gameData'][selectedGame].containsKey(selectedLevel)) {
      var levelData = widget.childData['gameData'][selectedGame][selectedLevel];

      if (levelData is List) {
        scoresList = levelData
            .map((entry) => {
                  "date": entry["timestamp"] is Timestamp
                      ? (entry["timestamp"] as Timestamp).toDate()
                      : entry["timestamp"] ?? entry["date"] ?? "Unknown",
                  "score": entry["score"] ?? 0
                })
            .toList();
      } else if (levelData is Map) {
        if (levelData.containsKey("lastScores")) {
          scoresList = List<Map<String, dynamic>>.from(levelData["lastScores"]);
        } else if (levelData.containsKey("scores")) {
          scoresList = List<Map<String, dynamic>>.from(levelData["scores"]);
        } else if (levelData.containsKey("highestScore")) {
          scoresList = [
            {"date": "N/A", "score": levelData["highestScore"]}
          ];
        }
      }
    }

    return scoresList;
  }

  Widget _noDataMessage() {
    return const Center(
      child: Text(
        'No data available',
        style: TextStyle(
            color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
