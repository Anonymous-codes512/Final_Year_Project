import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Kids_screens/Kids_Home.dart';
import 'Teenager/new_main.dart';

class ChildHomePage extends StatefulWidget {
  final String userName;
  final String
      userId; // Pass the user ID to fetch child details from Firestore.

  const ChildHomePage(
      {required this.userName, required this.userId, super.key});

  @override
  _ChildHomePageState createState() => _ChildHomePageState();
}

class _ChildHomePageState extends State<ChildHomePage> {
  @override
  void initState() {
    super.initState();
    _delayedCheck();
  }

  /// Delays for 3 seconds before checking the child's age.
  Future<void> _delayedCheck() async {
    await Future.delayed(const Duration(seconds: 3));
    _checkChildAge();
  }

  /// Function to fetch the child's age from Firestore and navigate accordingly.
  Future<void> _checkChildAge() async {
    try {
      // Reference to the Firestore document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Replace 'users' with your Firestore collection
          .doc(widget.userId) // The document ID is the user's ID.
          .get();

      // Extract age from the Firestore document
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        // Ensure the 'age' field exists in Firestore and is not null
        int age = int.tryParse(data['age'].toString()) ??
            0; // Default to 0 if 'age' is null

        // Navigate based on the age
        if (age >= 12) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LevelScreen(),
            ),
          );
        } else {
          final String uid = widget.userId;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => KidsHome(uid: uid),
            ),
          );
        }
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching age: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/images/First_page.gif', // Ensure the path matches your asset directory
              fit: BoxFit.cover,
            ),
          ),
          // Welcome Message
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Display the userName here, ensuring it's part of the welcome message
                // Text(
                //   widget.userName,
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.w500,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeenagerPage extends StatelessWidget {
  const TeenagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Teenager Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Teenager Page!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
