import 'package:final_year_project/child_pages/Kids_screens/profile/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewScreen extends StatelessWidget {
  final String kidName;
  final String avatar;

  const ProfileViewScreen(
      {super.key, required this.kidName, required this.avatar});

  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference profileDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_profiles')
          .doc(kidName);

      DocumentSnapshot profileSnapshot = await profileDoc.get();

      if (profileSnapshot.exists) {
        return profileSnapshot.data() as Map<String, dynamic>;
      } else {
        return {
          'name': kidName,
          'avatar': avatar,
          'hobby': 'Hobby',
          'favorite_subject': 'Favorite Subject',
          'gender': 'Male'
        }; // Return default values
      }
    } catch (e) {
      throw Exception("Error fetching profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            body: Center(child: Text("No Profile Data Found")),
          );
        }

        var profileData = snapshot.data!;
        String name = profileData['name'] ?? kidName;
        String hobby = profileData['hobby'] ?? 'Hobby';
        String favoriteSubject =
            profileData['favorite_subject'] ?? 'Favorite Subject';
        String gender = profileData['gender'] ?? 'Male';
        String avatar = profileData['avatar'] ?? 'assets/kids_profile.jpeg';
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow[200]!, width: 5),
                  ),
                  child: ClipOval(
                    child: Image.asset(avatar,
                        width: 100, height: 100, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Text(
                    'Name: $name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                      fontFamily: 'ComicSans',
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: const Color(0xFFfaf0e6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.subject,
                              color: Colors.purple, size: screenWidth * 0.08),
                          title: Text(
                            'Favorite Subject: $favoriteSubject',
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.person,
                              color: Colors.green, size: screenWidth * 0.08),
                          title: const Text('Gender'),
                          trailing: Text(gender),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.sports_esports,
                              color: Colors.orange, size: screenWidth * 0.08),
                          title: Text(
                            'Hobby: $hobby',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the Edit Profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(
                              kidName: kidName, avatar: avatar),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      minimumSize: Size(screenWidth * 0.5, 50),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
