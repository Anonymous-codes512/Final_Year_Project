import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarResultScreen extends StatefulWidget {
  final int score;
  final String level; // Game Level
  final String userId; // Game Level
  final String parentEmail; // Game Level

  const CarResultScreen(
      {super.key,
      required this.score,
      required this.level,
      required this.userId,
      required this.parentEmail});

  @override
  _CarResultScreenState createState() => _CarResultScreenState();
}

class _CarResultScreenState extends State<CarResultScreen> {
  int highestScore = 0;
  bool isNewHighestScore = false;

  @override
  void initState() {
    super.initState();
    fetchHighestScore();
  }

  Future<void> fetchHighestScore() async {
    try {
      String parentEmail =
          widget.parentEmail.toLowerCase().trim(); // Parent document ID
      String childId = widget.userId; // Child ID inside children array
      String gameName = "catch_the_ball"; // Game name
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

          // Ensure catch_the_ball data exists inside gameData
          if (children[i]["gameData"][gameName] == null) {
            print("🛠 Creating catch_the_ball field...");
            children[i]["gameData"][gameName] = {};
          }

          // Ensure level data exists inside catch_the_ball
          if (children[i]["gameData"][gameName][levelKey] == null) {
            print("🛠 Creating level field...");
            children[i]["gameData"][gameName]
                [levelKey] = {"highestScore": 0, "lastScores": []};
          }

          // Get the current highest score
          int highestScore =
              children[i]["gameData"][gameName][levelKey]["highestScore"] ?? 0;

          setState(() {
            this.highestScore = highestScore;
          });

          print("✅ Highest score for $childId at $levelKey is $highestScore");

          break;
        }
      }

      if (!childFound) {
        print("🚨 Child ID $childId NOT found under parent $parentEmail.");
        return;
      }
    } catch (e) {
      print("⚠️ Error fetching highest score: $e");
    }
  }

  Future<void> saveGameData(int score) async {
    try {
      String? parentEmail =
          widget.parentEmail?.toLowerCase().trim(); // Parent document ID
      String? childId = widget.userId; // Child ID inside children array

      // 🔥 Check if parentEmail or childId is null/empty
      if (parentEmail == null || parentEmail.isEmpty) {
        print("🚨 Error: parentEmail is null or empty.");
        return;
      }

      if (childId == null || childId.isEmpty) {
        print("🚨 Error: childId is null or empty.");
        return;
      }

      String gameName = "catch_the_ball"; // Game name
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

          // Ensure catch_the_ball data exists inside gameData
          if (children[i]["gameData"][gameName] == null) {
            print("🛠 Creating catch_the_ball field...");
            children[i]["gameData"][gameName] = {};
          }

          // Ensure level data exists inside catch_the_ball
          if (children[i]["gameData"][gameName][levelKey] == null) {
            print("🛠 Creating level field...");
            children[i]["gameData"][gameName]
                [levelKey] = {"highestScore": 0, "lastScores": []};
          }

          // Get the current highest score
          int highestScore =
              children[i]["gameData"][gameName][levelKey]["highestScore"] ?? 0;

          // Update highest score if the new score is greater
          bool isNewHighestScore = false;
          if (score > highestScore) {
            print("🎯 New highest score: $score (Previous: $highestScore)");
            children[i]["gameData"][gameName][levelKey]["highestScore"] = score;
            isNewHighestScore = true;
          }

          // Format the date as "DD-MM-YYYY"
          String formattedDate =
              DateFormat('dd-MM-yyyy').format(DateTime.now());

          // Append new score entry with date
          Map<String, dynamic> scoreEntry = {
            "score": score,
            "date": formattedDate, // Store only DD-MM-YYYY
          };

          List<dynamic> lastScores =
              children[i]["gameData"][gameName][levelKey]["lastScores"] ?? [];

          lastScores.add(scoreEntry); // Store all played scores without limit

          children[i]["gameData"][gameName][levelKey]["lastScores"] =
              lastScores;

          print(
              "✅ Score ${score} added to $levelKey with date $formattedDate for child $childId");

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

      // Show congratulatory message if a new highest score is achieved
      if (isNewHighestScore) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 Congratulations! New Highest Score!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("⚠️ Error saving game data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background for a modern look.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent,
              const Color.fromARGB(255, 111, 200, 241)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events,
                        size: 100, color: Colors.amber),
                    const SizedBox(height: 16),
                    const Text(
                      "Game Over!",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your Score: ${widget.score}",
                      style: const TextStyle(fontSize: 24, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Highest Score (${widget.level}): $highestScore",
                      style: const TextStyle(fontSize: 24, color: Colors.green),
                    ),
                    if (isNewHighestScore)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "New High Score!",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            saveGameData(widget.score);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Restart",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            saveGameData(widget.score);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Exit",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
