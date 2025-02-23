// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:final_year_project/child_pages/Kids_screens/profile/profile_kid.dart';
// import 'package:final_year_project/child_pages/Kids_screens/shapes_reading/shape_page.dart';
// import 'package:final_year_project/child_pages/Kids_screens/Progress_page/progress_screen.dart';

// import 'package:final_year_project/child_pages/Kids_screens/Reading_pages/Reading.dart';
// import 'package:final_year_project/child_pages/Kids_screens/games/games_page.dart';

// class KidsHome extends StatefulWidget {
//   const KidsHome({Key? key}) : super(key: key);

//   @override
//   State<KidsHome> createState() => _KidsHomeState();
// }

// class _KidsHomeState extends State<KidsHome> {
//   int _selectedIndex = 0;

//   List<Widget> _screens() {
//     return [
//       buildHomeScreen(),
//       KidsProfilePage(),
//     ];
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Widget buildHomeScreen() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Add a picture below the app bar
//           Container(
//             margin: const EdgeInsets.only(top: 8.0),
//             width: double.infinity,
//             child: Image.asset(
//               'assets/kids/kids_home.png', // Replace with your image path
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Grid section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: GridView.count(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16.0,
//               mainAxisSpacing: 16.0,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 buildGridItem(
//                   context,
//                   'assets/images/games.png',
//                   'Numbers',
//                   'All about number',
//                   const NumbersPage(),
//                   const Color(0xFFf7b4c6),
//                 ),
//                 buildGridItem(
//                   context,
//                   'assets/images/learning.png',
//                   'Reading',
//                   'Reading some words',
//                   ReadingPage(),
//                   const Color(0xFF3c5b61),
//                 ),
//                 buildGridItem(
//                   context,
//                   'assets/images/Progress.png',
//                   'Progress',
//                   'See your progress',
//                   ProgressGraphScreen(userId: 'userId'),
//                   const Color(0xFFfdbd46),
//                 ),
//                 buildGridItem(
//                   context,
//                   'assets/images/shapes.png',
//                   'Shapes',
//                   'Learn shapes',
//                   ShapesPage(),
//                   const Color(0xFFffde59),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildGridItem(BuildContext context, String imagePath, String title,
//       String subtitle, Widget page, Color color) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => page),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Flexible(
//               child: Image.asset(
//                 imagePath,
//                 width: MediaQuery.of(context).size.width * 0.3,
//                 height: MediaQuery.of(context).size.width * 0.3,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               subtitle,
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFFFF),
//       appBar: AppBar(
//         backgroundColor: Colors.orange.shade100,
//         elevation: 0,
//         centerTitle: true,
//         title: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc(FirebaseAuth.instance.currentUser!.uid)
//               .collection('kids_data')
//               .doc('child_profile')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Column(
//                 children: const [
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundImage: AssetImage('assets/kids/auto_profile.png'),
//                   ),
//                   SizedBox(height: 4),
//                   Text('Hello, Loading...', style: TextStyle(fontSize: 16)),
//                 ],
//               );
//             }

//             if (snapshot.hasError ||
//                 !snapshot.hasData ||
//                 !snapshot.data!.exists) {
//               return Column(
//                 children: const [
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundImage: AssetImage('assets/kids/auto_profile.png'),
//                   ),
//                   SizedBox(width: 4),
//                   Text('Hello, Guest', style: TextStyle(fontSize: 16)),
//                 ],
//               );
//             }

//             Map<String, dynamic> profileData =
//                 snapshot.data!.data() as Map<String, dynamic>;
//             String name = profileData['name'] ?? 'Guest';
//             String avatar =
//                 profileData['avatar'] ?? 'assets/kids/auto_profile.png';

//             return Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundImage: avatar.startsWith('assets')
//                       ? AssetImage(avatar) as ImageProvider
//                       : NetworkImage(avatar),
//                 ),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Hello, $name',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       body: _screens()[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Colors.white,
//         selectedItemColor: const Color(0xFFFF9F29),
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
