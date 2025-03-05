import 'package:final_year_project/Parent_pages/game_stats_selection_screen.dart';
import 'package:final_year_project/Parent_pages/set_game_limit.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/Authentication/login_screen.dart';
import 'package:final_year_project/Chatbot/chat_screen.dart';
import 'package:final_year_project/Education/education_screen.dart';
import 'package:final_year_project/Group_Chat/groupchat.dart';
import 'parent_home.dart';
import 'book_appointment.dart';
import 'appointment_status.dart';

class ParentHomeScreen extends StatefulWidget {
  final String userName;
  final String parentEmail;

  const ParentHomeScreen({
    required this.userName,
    required this.parentEmail,
    super.key,
  });

  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  // Function to handle navigation
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Function to handle logout
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Homes'),
        backgroundColor: const Color.fromARGB(255, 248, 208, 49),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 214, 202, 157), // Background color
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildClickableContainer(
                      label: 'Register \nChildren',
                      imagePath: 'assets/children.png',
                      onTap: () => _navigateToScreen(
                        ParentHome(
                            userName: widget.userName,
                            parentEmail: widget.parentEmail),
                      ),
                      containerColor: const Color(0xFFF7B4C6),
                      textColor: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      isHome: true,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildClickableContainer(
                            label: 'Book Appointment',
                            imagePath: 'assets/appointment.png',
                            onTap: () => _navigateToScreen(
                              BookAppointment(parentEmail: widget.parentEmail),
                            ),
                            containerColor: const Color(0xFF373E37),
                            textColor: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.47,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildClickableContainer(
                            label: 'Status',
                            imagePath: 'assets/status.png',
                            onTap: () => _navigateToScreen(
                              AppointmentStatus(
                                  parentEmail: widget.parentEmail),
                            ),
                            containerColor: const Color(0xFFFFDE59),
                            textColor: Colors.black,
                            width: MediaQuery.of(context).size.width * 0.47,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildClickableContainer(
                            label: 'Education',
                            imagePath: 'assets/education.png',
                            onTap: () => _navigateToScreen(EducationScreen()),
                            containerColor: const Color(0xFFFFDE59),
                            textColor: Colors.black,
                            width: MediaQuery.of(context).size.width * 0.47,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildClickableContainer(
                            label: 'Group Chat',
                            imagePath: 'assets/groupchat.png',
                            onTap: () => _navigateToScreen(GroupChat()),
                            containerColor: const Color(0xFF373E37),
                            textColor: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.47,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildClickableContainers(
                      label: 'Set Game Limit',
                      imagePath: 'assets/Set Limit.png',
                      onTap: () => _navigateToScreen(SetGameLimit()),
                      containerColor: const Color(0xFFdd5851),
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      isHome: true,
                    ),
                    const SizedBox(height: 8),
                    _buildClickableContainer(
                      label: 'View Game Stats',
                      imagePath: 'assets/stats.png',
                      onTap: () => _navigateToScreen(GameStatsScreen()),
                      containerColor: const Color(0xFF332F46),
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width - 10,
                      isHome: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Chatbot screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: const Color(0xFFFFDE59), // Yellow
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  // Reusable clickable container widget with dynamic width and image size
  Widget _buildClickableContainer({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
    required double width, // Dynamic width for the container
    required Color containerColor, // Dynamic container color
    required Color textColor, // Dynamic text color
    bool isHome = false, // Flag to check if it's the Home screen
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, // Set width dynamically
        height: isHome ? 160 : 150, // Increased height of containers
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: isHome
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath,
                      height: 130, width: 130), // Increased image size
                  const SizedBox(width: 16),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20, // Increased font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath,
                      height: 80, width: 80), // Increased image size
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20, // Increased font size
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildClickableContainers({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
    required double width, // Dynamic width for the container
    required Color containerColor, // Dynamic container color
    required Color textColor, // Dynamic text color
    bool isHome = false, // Flag to check if it's the Home screen
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, // Set width dynamically
        height: 100, // Increased height of containers
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: isHome
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath,
                      height: 130, width: 130), // Increased image size
                  const SizedBox(width: 16),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20, // Increased font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath,
                      height: 80, width: 80), // Increased image size
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20, // Increased font size
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
