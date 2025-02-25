import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsScreen extends StatefulWidget {
  final String gameName;
  final Color gameColor;

  const StatsScreen({
    super.key,
    required this.gameName,
    required this.gameColor,
  });

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, Map<String, List<int>>> childrenGameData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChildrenData();
  }

  Future<void> _fetchChildrenData() async {
    // debugCheckUsersCollection();
    String? parentEmail = FirebaseAuth.instance.currentUser?.email;
    if (parentEmail == null || parentEmail.isEmpty) {
      print("🔥 Parent email is empty or null.");
      setState(() => isLoading = false);
      return;
    }

    parentEmail = parentEmail.toLowerCase().trim(); // Convert to lowercase

    print("🔍 Querying Firestore for parent email: $parentEmail");

    try {
      // Fetch parent document
      DocumentSnapshot parentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(parentEmail)
          .get();

      if (!parentDoc.exists) {
        print("🚨 No document found for parent email: $parentEmail");
        setState(() => isLoading = false);
        return;
      }

      print("✅ Parent document found!");

      // Extract children list
      List<dynamic>? childrenList =
          (parentDoc.data() as Map<String, dynamic>?)?["children"];

      if (childrenList == null || childrenList.isEmpty) {
        print("🚨 No children found for parent: $parentEmail");
        setState(() => isLoading = false);
        return;
      }

      print("👶 Available children: $childrenList");

      // Fetch each child's game data
      for (var child in childrenList) {
        if (child is Map<String, dynamic> && child.containsKey("childId")) {
          String childId = child["childId"];
          print("📊 Fetching game data for child: $childId");
          await _fetchGameDataForChild(childId);
        } else {
          print("⚠️ Invalid child data format: $child");
        }
      }
    } catch (e) {
      print("⚠️ Error fetching children data: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> debugCheckUsersCollection() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();

    print("📂 Listing all user document IDs:");
    for (var doc in querySnapshot.docs) {
      print("📄 User Document ID: ${doc.id}");
    }
  }

  Future<void> _fetchGameDataForChild(String childId) async {
    try {
      print("🔍 Fetching game data for child ID: $childId");

      // Fetch parent document where children data is stored
      String? parentEmail = FirebaseAuth.instance.currentUser?.email;
      if (parentEmail == null) {
        print("🔥 Parent email is null.");
        return;
      }

      DocumentSnapshot parentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(parentEmail)
          .get();

      if (!parentDoc.exists) {
        print("🚨 No document found for parent email: $parentEmail");
        return;
      }

      // Extract children list
      List<dynamic>? childrenList =
          (parentDoc.data() as Map<String, dynamic>?)?["children"];

      if (childrenList == null || childrenList.isEmpty) {
        print("🚨 No children found for parent: $parentEmail");
        return;
      }

      // Find the specific child's data inside the array
      Map<String, dynamic>? childData;
      for (var child in childrenList) {
        if (child is Map<String, dynamic> && child["childId"] == childId) {
          childData = child;
          break;
        }
      }

      if (childData == null) {
        print("🚨 Child ID $childId not found under parent $parentEmail.");
        return;
      }

      print("✅ Child Data Found: $childData");

      // Check if game data is inside the child object
      if (childData.containsKey("gameData")) {
        print("🎮 Game Data Found: ${childData["gameData"]}");
      } else {
        print("🚨 No `gameData` field found for child: $childId");
      }
    } catch (e) {
      print("⚠️ Error fetching game data for child $childId: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: widget.gameColor,
        title: Text(
          '${widget.gameName} Analytics',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : childrenGameData.isEmpty
              ? Center(child: Text("No data available."))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: childrenGameData.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Child ID: ${entry.key}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
