import 'package:flutter/material.dart';

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
      selectedLevel = null; // Reset level when a new game is selected
      levelNames =
          widget.childData['gameData'][selectedGame]?.keys.toList() ?? [];
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
              SizedBox(
                height: 500,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: selectedGame != null && selectedLevel != null
                      ? _buildScoreList(
                          widget.childData, selectedGame!, selectedLevel!)
                      : Center(
                          child: Text("Select a game and level to view scores",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500))),
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

  Widget _buildScoreList(
      Map<String, dynamic> childData, String game, String level) {
    List<Map<String, dynamic>> scoresList = [];

    if (childData.containsKey('gameData') &&
        childData['gameData'] is Map &&
        childData['gameData'].containsKey(game) &&
        childData['gameData'][game] is Map &&
        childData['gameData'][game].containsKey(level)) {
      var levelData = childData['gameData'][game][level];

      if (levelData is List) {
        scoresList = levelData
            .map((entry) => {
                  "date": entry["timestamp"] ?? entry["date"] ?? "Unknown Date",
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

    return scoresList.isNotEmpty
        ? ListView.builder(
            itemCount: scoresList.length,
            itemBuilder: (context, index) {
              var entry = scoresList[index];
              return Card(
                color: const Color(0xFFDADADA), // Changed Card color to blue
                elevation: 4,
                // margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF332F46),
                    child: Icon(Icons.date_range, color: Colors.white),
                  ),
                  title: Text("Date: ${entry['date']}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text("Score: ${entry['score']}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ),
              );
            },
          )
        : Center(
            child: Text('No data available',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          );
  }
}
