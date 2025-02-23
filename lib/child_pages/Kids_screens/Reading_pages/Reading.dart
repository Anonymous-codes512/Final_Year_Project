import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_year_project/child_pages/Kids_screens/Reading_pages/story1.dart';
import 'package:final_year_project/child_pages/Kids_screens/Reading_pages/story3.dart';

class ReadingPage extends StatelessWidget {
  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the gradient behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_reading.png', // Your background image
              fit: BoxFit.cover, // Ensure the image covers the entire screen
            ),
          ),
          // Content on top of the background
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Read Stories",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000), // Playful green
                      fontFamily: 'Comic Sans MS',
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  buildGameButton(
                    context,
                    'Time story',
                    const Color(0xFFffde59), // Amber
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Story1Page()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  buildGameButton(
                    context,
                    'Count story ',
                    const Color(0xFFffde59), // Light Green
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StoryPage2()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  buildGameButton(
                    context,
                    'Tables ',
                    const Color(0xFFffde59), // Light Blue
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Story3Page()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Explore and Learn!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _launchURL();
                      },
                      child: const Text(
                        'Visit website for more stories!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to launch a URL (dummy URL for now)
  void _launchURL() async {
    const url =
        'https://freekidsbooks.org/subject/maths/'; // Replace with your actual URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildGameButton(
      BuildContext context, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.zero, // Removed rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Comic Sans MS',
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black38,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoryPage2 extends StatefulWidget {
  const StoryPage2({super.key});

  @override
  _StoryPage2State createState() => _StoryPage2State();
}

class _StoryPage2State extends State<StoryPage2> {
  // List of images to display
  final List<String> _images = [
    'assets/Story2/image1.png', // Add your image paths here
    'assets/Story2/image2.png',
    'assets/Story2/image3.png',
    'assets/Story2/image4.png',
    'assets/Story2/image5.png',
    'assets/Story2/image6.png',
    'assets/Story2/image7.png',
    'assets/Story2/image8.png',
    'assets/Story2/image9.png',
    'assets/Story2/image10.png',
  ];

  // Index to track the current image
  int _currentIndex = 0;

  // Function to update the image
  void _changeImage(int indexChange) {
    setState(() {
      _currentIndex = (_currentIndex + indexChange) % _images.length;
      if (_currentIndex < 0) {
        _currentIndex += _images.length; // Handle negative index
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leg Count '),
        backgroundColor: const Color(0xFFa3b68a),
      ),
      body: Stack(
        children: [
          // Display the current image
          Center(
            child: Image.asset(
              _images[_currentIndex],
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
          // Left navigation button
          Positioned(
            left: 20,
            top: MediaQuery.of(context).size.height / 2 - 40,
            child: GestureDetector(
              onTap: () => _changeImage(-1),
              child: const Icon(
                Icons.arrow_left,
                size: 60,
                color: Color(0xFFa3b68a),
              ),
            ),
          ),
          // Right navigation button
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height / 2 - 40,
            child: GestureDetector(
              onTap: () => _changeImage(1),
              child: const Icon(
                Icons.arrow_right,
                size: 60,
                color: Color(0xFFa3b68a),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryPage4 extends StatelessWidget {
  const StoryPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story 4'),
        backgroundColor: const Color(0xFFa3b68a),
      ),
      body: const Center(
        child: Text('Content for Story 4'),
      ),
    );
  }
}


/*import 'package:final_year_project/child_pages/Kids_screens/Reading_pages/story1.dart';
import 'package:final_year_project/child_pages/Kids_screens/Reading_pages/story3.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf0e6),
      appBar: AppBar(
        title: const Text(
          'Reading Page',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFfaf0e6),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2, // Two containers per row
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true, // Allow GridView inside SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
                children: [
                  _buildContainer(context, 'Story 1', const Color(0xFFa3b68a),  Story1Page()),
                  _buildContainer(context, 'Story 2', const Color(0xFFa3b68a), const StoryPage2()),
                  _buildContainer(context, 'Story 3', const Color(0xFFa3b68a),  Story3Page()),
                  _buildContainer(context, 'Story 4', const Color(0xFFa3b68a), const StoryPage4()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Explore and Learn!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle link action here
                },
                child: const Text(
                  'Visit our website for more stories!',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(
      BuildContext context, String title, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        height: 100, // Adjust size for smaller containers
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


class StoryPage2 extends StatefulWidget {
  const StoryPage2({super.key});

  @override
  _StoryPage2State createState() => _StoryPage2State();
}

class _StoryPage2State extends State<StoryPage2> {
  // List of images to display
  final List<String> _images = [
    'assets/Story2/image1.png', // Add your image paths here
    'assets/Story2/image2.png',
    'assets/Story2/image3.png',
    'assets/Story2/image4.png',
    'assets/Story2/image5.png',
    'assets/Story2/image6.png',
    'assets/Story2/image7.png',
    'assets/Story2/image8.png',
    'assets/Story2/image9.png',
    'assets/Story2/image10.png',
  ];

  // Index to track the current image
  int _currentIndex = 0;

  // Function to update the image
  void _changeImage(int indexChange) {
    setState(() {
      _currentIndex = (_currentIndex + indexChange) % _images.length;
      if (_currentIndex < 0) _currentIndex += _images.length; // Handle negative index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leg Count '),
        backgroundColor: const Color(0xFFa3b68a),
      ),
      body: Stack(
        children: [
          // Display the current image
          Center(
            child: Image.asset(
              _images[_currentIndex],
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
          // Left navigation button
          Positioned(
            left: 20,
            top: MediaQuery.of(context).size.height / 2 - 40,
            child: GestureDetector(
              onTap: () => _changeImage(-1),
              child: const Icon(
                Icons.arrow_left,
                size: 60,
                color: Color(0xFFa3b68a),
              ),
            ),
          ),
          // Right navigation button
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height / 2 - 40,
            child: GestureDetector(
              onTap: () => _changeImage(1),
              child: const Icon(
                Icons.arrow_right,
                size: 60,
                color: Color(0xFFa3b68a),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryPage4 extends StatelessWidget {
  const StoryPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story 4'),
        backgroundColor: const Color(0xFFa3b68a),
      ),
      body: const Center(
        child: Text('Content for Story 4'),
      ),
    );
  }
}
*/