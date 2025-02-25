import 'package:final_year_project/Parent_pages/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameStatsScreen extends StatelessWidget {
  const GameStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Game Stats Options',
          style: TextStyle(color: Color(0Xffffffff)),
        ),
        backgroundColor: const Color(0xFF332F46),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFF332F46),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please Select Game',
                    style: GoogleFonts.sigmar(
                      fontSize: 36,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 50),
                  _buildLevelCard(
                    context,
                    'additionGame',
                    Icons.add_circle,
                    Colors.green.shade400,
                  ),
                  const SizedBox(height: 20),
                  _buildLevelCard(
                    context,
                    'shapes game',
                    Icons.category,
                    Colors.orange.shade400,
                  ),
                  const SizedBox(height: 20),
                  _buildLevelCard(
                    context,
                    'catch the ball',
                    Icons.sports_soccer,
                    Colors.red.shade400,
                  ),
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
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        // Pass the game name and color to the StatsScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StatsScreen(gameName: title, gameColor: color),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x85000000),
              offset: Offset(0, 0),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
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
