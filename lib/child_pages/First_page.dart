import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Kids_screens/Kids_Home.dart';
import 'Teenager/teenager_level_screen.dart';

class ChildHomePage extends StatefulWidget {
  final String userName;
  final String userId;
  final String parentEmail;

  const ChildHomePage(
      {required this.userName,
      required this.userId,
      required this.parentEmail,
      super.key});

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
      // Fetch the parent's document using the parent's email.
      DocumentSnapshot parentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.parentEmail) // parent's email is used as the document ID
          .get();

      if (parentDoc.exists) {
        Map<String, dynamic> parentData =
            parentDoc.data() as Map<String, dynamic>;
        List<dynamic> children = parentData['children'] ?? [];

        // Find the child's record by matching the child's ID.
        Map<String, dynamic>? childData;
        for (var child in children) {
          if (child['childId'] == widget.userId) {
            childData = child;
            break;
          }
        }
        if (childData == null) {
          print('Child record not found in the parent document');
          return;
        }

        // Parse the child's age.
        int age = int.tryParse(childData['age'].toString()) ?? 0;

        // Navigate based on the child's age.
        if (age >= 12) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LevelScreen(
                  uid: widget.userId, parentEmail: widget.parentEmail),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  KidsHome(uid: widget.userId, parentEmail: widget.parentEmail),
            ),
          );
        }
      } else {
        print('Parent document does not exist');
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
