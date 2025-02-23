import 'package:flutter/material.dart';
import 'package:final_year_project/Authentication/Login_Screen.dart';
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
        title: const Text('Parent Home'),
        backgroundColor: const Color(0xFFFFDE59),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Added to make sure the content scrolls if needed
        child: Container(
          color: const Color(0xFFF7F7F7), // Off-white background color
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Register Children Container (Black Shade)
              _buildClickableContainer(
                label: 'Register \nChildren',
                imagePath: 'assets/children.png',
                onTap: () => _navigateToScreen(
                  ParentHome(
                      userName: widget.userName,
                      parentEmail: widget.parentEmail),
                ),
                width: MediaQuery.of(context).size.width, // Full width
                containerColor: const Color(0xFFF7B4C6), // Black shade color
                textColor: Colors.black,
                isHome: true, // Flag to indicate if it's the home container
              ),
              const SizedBox(height: 8), // Reduced spacing between containers
              // Row 1: Book Appointment (Yellow) and Status (Pink)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildClickableContainer(
                    label: 'Book Appointment',
                    imagePath: 'assets/appointment.png',
                    onTap: () => _navigateToScreen(
                      BookAppointment(parentEmail: widget.parentEmail),
                    ),
                    width:
                        MediaQuery.of(context).size.width * 0.45, // Half width
                    containerColor: const Color(0xFF373E37), // Yellow
                    textColor: Colors.white,
                  ),
                  _buildClickableContainer(
                    label: 'Status',
                    imagePath: 'assets/status.png',
                    onTap: () => _navigateToScreen(
                      AppointmentStatus(parentEmail: widget.parentEmail),
                    ),
                    width:
                        MediaQuery.of(context).size.width * 0.45, // Half width
                    containerColor: const Color(0xFFFFDE59), // Pink
                    textColor: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 8), // Reduced spacing between containers
              // Row 2: Education (Pink) and Group Chat (Black)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildClickableContainer(
                    label: 'Education',
                    imagePath: 'assets/education.png',
                    onTap: () => _navigateToScreen(EducationScreen()),
                    width:
                        MediaQuery.of(context).size.width * 0.45, // Half width
                    containerColor: const Color(0xFFFFDE59), // Pink
                    textColor: Colors.black,
                  ),
                  _buildClickableContainer(
                    label: 'Group Chat',
                    imagePath: 'assets/groupchat.png',
                    onTap: () => _navigateToScreen(GroupChat()),
                    width:
                        MediaQuery.of(context).size.width * 0.45, // Half width
                    containerColor: const Color(0xFF373E37), // Black
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 8), // Reduced spacing between containers
            ],
          ),
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
        height: isHome ? 170 : 150, // Increased height of containers
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
                      fontSize: 24, // Increased font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
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
