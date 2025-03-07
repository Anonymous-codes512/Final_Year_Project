import 'package:final_year_project/child_pages/subscription_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Addition_Game/kids_level_screen.dart';
import 'car_game/car_level_selection_Screen.dart';
import 'package:final_year_project/child_pages/Kids_screens/games/shape_game/screens_ShapeGame/shape_splash_screen.dart';

class NumbersPage extends StatefulWidget {
  final String userId;
  final String parentEmail;

  const NumbersPage(
      {required this.userId, required this.parentEmail, super.key});

  @override
  _NumbersPageState createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_games1.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Let's Play",
                style: GoogleFonts.sigmar(
                  textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF28500),
                  ),
                ),
              ),
              Text(
                " and",
                style: GoogleFonts.sigmar(
                  textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF28500),
                  ),
                ),
              ),
              Text(
                "Learn!",
                style: GoogleFonts.sigmar(
                  textStyle: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF28500),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  buildGameButton(context, 'Addition Game', Icons.add_circle,
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KidsLevelScreen(
                                userId: widget.userId,
                                parentEmail: widget.parentEmail)));
                  }),
                  buildGameButton(context, 'Shapes Game', Icons.category, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShapeSplashScreen(
                              userId: widget.userId,
                              parentEmail: widget.parentEmail)),
                    );
                  }),
                  buildGameButton(
                      context, 'Catch the Ball!', Icons.sports_soccer, () {
                    print({widget.parentEmail});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarLevelSelectionScreen(
                              userId: widget.userId,
                              parentEmail: widget.parentEmail)),
                    );
                  }),
                  buildGameButton(
                      context, 'See Subscriptions', Icons.add_circle, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubscriptionPlanScreen(
                              themeColor: Color(0xFFF28500))),
                    );
                  }),
                ],
              ),
              // const SizedBox(height: 0),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_animation.value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/duolingoo.png', // Ensure you have the Duolingo icon in assets
                  width: 200,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGameButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF28500),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
