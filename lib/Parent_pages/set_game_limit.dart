import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetGameLimit extends StatefulWidget {
  const SetGameLimit({super.key});

  @override
  _SetGameLimitState createState() => _SetGameLimitState();
}

class _SetGameLimitState extends State<SetGameLimit> {
  void _saveGameLimit(String gameName, int limit) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "guest";
    await FirebaseFirestore.instance.collection('users').doc(userId).set(
      {
        gameName: {'Limit': limit}
      },
      SetOptions(merge: true),
    );
  }

  void _showLimitDialog(String gameName) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: Text(
            'Set Limit for $gameName',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Limit',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
              onPressed: () async {
                final value = int.tryParse(controller.text);
                if (value != null && value > 0) {
                  _saveGameLimit(gameName, value); // Save to Firebase

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Limit set to $value for $gameName')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please enter a number greater than 0')),
                  );
                }
              },
              child: Text(
                'Set',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Game Limit',
          style: TextStyle(color: Color(0XFFFFFFFF)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffdd5851),
        iconTheme: IconThemeData(color: Color(0XFFFFFFFF)),
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFdd5851), Color.fromARGB(255, 225, 113, 107)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildSectionTitle('Teenager'),
              _buildGameCard('quiz', 'Quiz', Icons.add_circle),
              SizedBox(height: 16),
              _buildSectionTitle('Kid'),
              _buildGameCard(
                  'AdditionaGame', 'Additional Game', Icons.add_circle),
              _buildGameCard('shape_game', 'Shapes Game', Icons.category),
              _buildGameCard(
                  'catch_the_ball', 'Catch the Ball', Icons.sports_soccer),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF)),
      ),
    );
  }

  Widget _buildGameCard(String gameName, String showName, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Icon(icon, size: 30), // Added icon
          title: Text(showName, style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLimitDialog(gameName),
        ),
      ),
    );
  }
}
