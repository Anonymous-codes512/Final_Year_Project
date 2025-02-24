import 'package:final_year_project/child_pages/Kids_screens/games/car_game/car_game.dart';
import 'package:flutter/material.dart';
// import 'game_screen.dart';
import 'package:lottie/lottie.dart';

class CarLevelSelectionScreen extends StatefulWidget {
  const CarLevelSelectionScreen({super.key});

  @override
  _CarLevelSelectionScreenState createState() =>
      _CarLevelSelectionScreenState();
}

class _CarLevelSelectionScreenState extends State<CarLevelSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Level Selection',
            style: TextStyle(color: Color(0xffffffff)),
          ),
          backgroundColor: const Color.fromARGB(255, 239, 77, 77),
          iconTheme: IconThemeData(
            color: Colors.white,
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 251, 196, 196),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Lottie.asset('assets/animation/Animation2.json'),
                  ),
                  const SizedBox(height: 25),

                  _buildLevelCard(
                    context,
                    'Easy',
                    Icons.looks_one,
                    'Start with simple levels!',
                    Colors.green.shade400,
                    KidCarGame(
                      level: 'Easy',
                      carImage: 'assets/games/green car.png',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildLevelCard(
                    context,
                    'Medium',
                    Icons.looks_two,
                    'Challenge yourself a bit more!',
                    Colors.orange.shade400,
                    KidCarGame(
                      level: 'Medium',
                      carImage: 'assets/games/orange car.png',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildLevelCard(
                    context,
                    'Hard',
                    Icons.trending_up,
                    'Get ready for tough challenges!',
                    Colors.red.shade400,
                    KidCarGame(
                      level: 'Hard',
                      carImage: 'assets/games/red car.png',
                    ),
                  ),

                  // _buildLevelCard(
                  //   context,
                  //   'Advanced',
                  //   Icons.star,
                  //   'Only for the best players!',
                  //   Colors.red.shade400,
                  //   GameScreen(
                  //     level: 'Advanced',
                  //     themeColor: Colors.red.shade400,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    Color color,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(93, 125, 125, 125),
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          shadowColor: const Color(0xD1CBCBCB),
          color: color.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
