import 'package:final_year_project/child_pages/Kids_screens/games/games_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _leftAnimation;
  late Animation<Offset> _rightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _leftAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-1.5, 0), // Move left out of screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rightAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(1.5, 0), // Move right out of screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().then((_) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NumbersPage(userId: '', parentEmail: '')));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SlideTransition(
            position: _leftAnimation,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/left.png', height: double.infinity),
            ),
          ),
          SlideTransition(
            position: _rightAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset('assets/right.png', height: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
