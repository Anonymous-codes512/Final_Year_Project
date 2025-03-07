import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/child_pages/Kids_screens/profile/profile_kid.dart';
import 'package:final_year_project/child_pages/Kids_screens/shapes_reading/shape_page.dart';
import '../../Authentication/login_screen.dart';
import 'Progress_page/progress_screen.dart';
import 'Reading_pages/Reading.dart';
import 'games/games_page.dart';

class KidsHome extends StatefulWidget {
  final String uid;
  final String parentEmail;

  const KidsHome({super.key, required this.uid, required this.parentEmail});

  @override
  State<KidsHome> createState() => _KidsHomeState();
}

class _KidsHomeState extends State<KidsHome> {
  int _selectedIndex = 0;

  Future<Map<String, dynamic>?> fetchKidData() async {
    try {
      // Fetch the parent's document using the parent's email.
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.parentEmail)
          .get();

      if (parentSnapshot.exists) {
        Map<String, dynamic> parentData =
            parentSnapshot.data() as Map<String, dynamic>;
        List children = parentData['children'] ?? [];

        // Search for the child in the "children" array.
        for (var child in children) {
          if (child['childId'] == widget.uid) {
            return child as Map<String, dynamic>;
          }
        }
        return null; // Child not found.
      } else {
        return null; // Parent document doesn't exist.
      }
    } catch (e) {
      debugPrint("Error fetching kid data: $e");
      return null;
    }
  }

  List<Widget> _screens(String kidName, String avatar) {
    return [
      buildHomeScreen(kidName, avatar),
      ProfileViewScreen(kidName: kidName, avatar: avatar),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildHomeScreen(String kidName, String avatar) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 60.0), // Space before the bottom nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              width: double.infinity,
              child: Image.asset(
                'assets/kids/kids_home.png',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: avatar.startsWith('assets')
                        ? AssetImage(avatar) as ImageProvider
                        : NetworkImage(avatar),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hello, $kidName!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildGridItem(
                    context,
                    'assets/images/games.png',
                    'Numbers',
                    'Fun with numbers!',
                    NumbersPage(
                      userId: widget.uid,
                      parentEmail: widget.parentEmail,
                    ),
                    Colors.blue.shade300,
                  ),
                  buildGridItem(
                    context,
                    'assets/images/learning.png',
                    'Reading',
                    'Let\'s read some words!',
                    const ReadingPage(),
                    Colors.pink.shade200,
                  ),
                  buildGridItem(
                    context,
                    'assets/images/progress.png',
                    'Progress',
                    'See how much you\'ve learned!',
                    ProgressGraphScreen(userId: widget.uid),
                    Colors.orange.shade300,
                  ),
                  buildGridItem(
                    context,
                    'assets/images/shapes.png',
                    'Shapes',
                    'Discover shapes!',
                    ShapesPage(),
                    Colors.yellow.shade300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String imagePath, String title,
      String subtitle, Widget page, Color color) {
    return GestureDetector(
      onTap: () {
        print('User Is : ${widget.uid} & Parent Mail : ${widget.parentEmail}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1)
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                imagePath,
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Comic Sans MS',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Home'),
        backgroundColor: const Color(0xFFF9D77E),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFBF8C4),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchKidData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Failed to load data"));
          }

          String kidName = snapshot.data?['name'] ?? 'Guest';
          String avatar =
              snapshot.data?['avatar'] ?? 'assets/kids/kid_auto_profile.png';

          return _screens(kidName, avatar)[_selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.orange.shade100,
        selectedItemColor: const Color(0xFFFF9F29),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
