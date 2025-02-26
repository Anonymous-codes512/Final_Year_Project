import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/Parent_pages/stats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameStatsScreen extends StatefulWidget {
  const GameStatsScreen({super.key});

  @override
  _GameStatsScreenState createState() => _GameStatsScreenState();
}

class _GameStatsScreenState extends State<GameStatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userEmail;
  List<Map<String, dynamic>> children = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });

      if (userEmail != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userEmail).get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          if (data.containsKey('children') && data['children'] is List) {
            setState(() {
              children = List<Map<String, dynamic>>.from(data['children']);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Children List",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0XFFFFFFFF))),
        backgroundColor: Color(0xFF332F46),
        iconTheme: IconThemeData(color: Color(0XFFFFFFFF)),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF332F46), Color(0xFF48435F)],
          ),
        ),
        child: userEmail == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : children.isEmpty
                ? const Center(
                    child: Text(
                      "No children found",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      final child = children[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              child['name']?.substring(0, 1).toUpperCase() ??
                                  '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            child['name'] ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Age: ${child['age'] ?? 'N/A'}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey)),
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StatsScreen(childData: child),
                              ),
                            )
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
