import 'package:final_year_project/child_pages/Kids_screens/games/car_game/car_game.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'subscription_plan_screen.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/Addition_Game/game_screen.dart';

class CheckSubscriptionScreen extends StatefulWidget {
  final String parentEmail;
  final Color themeColor;
  final String level;
  final String userId;
  final String gameName;
  final String? carImage; // asset path for the car image

  const CheckSubscriptionScreen({
    super.key,
    required this.parentEmail,
    required this.themeColor,
    required this.level,
    required this.userId,
    required this.gameName,
    this.carImage,
  });

  @override
  State<CheckSubscriptionScreen> createState() =>
      _CheckSubscriptionScreenState();
}

class _CheckSubscriptionScreenState extends State<CheckSubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    try {
      // Fetch parent data based on email
      QuerySnapshot<Map<String, dynamic>> parentDocs = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: widget.parentEmail.toLowerCase().trim())
          .limit(1) // Limit to one document for efficiency
          .get();

      if (parentDocs.docs.isEmpty) {
        print("No parent found with this email: ${widget.parentEmail}");
        return; // Stop execution if no user is found
      }

      var subscription = parentDocs.docs.first.data()['subscriptionPlan'];
      if (subscription == 'null') {
        _navigateToScreen(
            SubscriptionPlanScreen(themeColor: widget.themeColor));
      } else {
        if (widget.gameName == 'Additional_game') {
          _navigateToScreen(GameScreen(
            level: widget.level,
            themeColor: widget.themeColor,
            userId: widget.userId,
            parentEmail: widget.parentEmail,
          ));
        } else if (widget.gameName == 'catch_the_ball') {
          _navigateToScreen(
            KidCarGame(
              level: widget.level,
              carImage: widget.carImage!,
              userId: widget.userId,
              parentEmail: widget.parentEmail,
            ),
          );
        }
      }
    } catch (e) {
      print("Error fetching subscription: $e");
    }
  }

  void _navigateToScreen(Widget screen) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeColor,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
