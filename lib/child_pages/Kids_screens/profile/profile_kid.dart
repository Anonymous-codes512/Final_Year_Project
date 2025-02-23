import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KidsProfilePage extends StatefulWidget {
  final String kidName;
  final String avatar;

  const KidsProfilePage(
      {super.key, required this.kidName, required this.avatar});

  @override
  _KidsProfilePage createState() => _KidsProfilePage();
}

class _KidsProfilePage extends State<KidsProfilePage> {
  bool isEditing = false;

  final nameController = TextEditingController();
  final hobbyController = TextEditingController();
  final favoriteSubjectController = TextEditingController();
  String selectedGender = 'Male';
  String selectedAvatar = 'assets/kids_profile.jpeg';

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference profileDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile_data')
          .doc('user_profile');

      DocumentSnapshot profileSnapshot = await profileDoc.get();

      if (profileSnapshot.exists) {
        Map<String, dynamic> profileData =
            profileSnapshot.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = profileData['name'] ?? 'Charlie';
          hobbyController.text = profileData['hobby'] ?? 'Playing puzzles';
          favoriteSubjectController.text =
              profileData['favorite_subject'] ?? 'Math';
          selectedGender = profileData['gender'] ?? 'Male';
          selectedAvatar = profileData['avatar'] ?? 'assets/kids_profile.jpeg';
        });
      } else {
        setState(() {
          nameController.text = 'Enter Name';
          hobbyController.text = 'Hobby';
          favoriteSubjectController.text = 'Favorite Subject';
          selectedAvatar = 'assets/kids_profile.jpeg';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching profile: $e')));
    }
  }

  Future<void> saveProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference profileDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profile_data')
          .doc('user_profile');

      Map<String, dynamic> profileData = {
        'name': nameController.text.trim(),
        'favorite_subject': favoriteSubjectController.text.trim(),
        'gender': selectedGender,
        'hobby': hobbyController.text.trim(),
        'avatar': selectedAvatar,
      };

      await profileDoc.set(profileData);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')));

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  void _showAvatarSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an Avatar'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount:
                  9, // You can update this to match the actual number of avatars
              itemBuilder: (BuildContext context, int index) {
                String avatarUrl =
                    'assets/kids/avatars/avatar_$index.png'; // Ensure these avatars exist in the assets folder
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatar = avatarUrl;
                    });
                    Navigator.pop(context);
                  },
                  child: Image.asset(avatarUrl, fit: BoxFit.cover),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Stack(
              children: [
                Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow[200]!, width: 5),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      selectedAvatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 30),
                      onPressed: () {
                        _showAvatarSelectionDialog(context);
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            isEditing
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: TextFormField(
                      controller: nameController,
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontFamily: 'ComicSans',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Text(
                      nameController.text,
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
                      title: isEditing
                          ? TextFormField(
                              controller: favoriteSubjectController,
                              decoration: const InputDecoration(
                                labelText: 'Favorite Subject',
                                border: OutlineInputBorder(),
                              ),
                            )
                          : Text(favoriteSubjectController.text),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.person,
                          color: Colors.green, size: screenWidth * 0.08),
                      title: const Text('Gender'),
                      trailing: isEditing
                          ? DropdownButton<String>(
                              value: selectedGender,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGender = newValue!;
                                });
                              },
                              items: <String>[
                                'Male',
                                'Female',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          : Text(selectedGender),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.sports_esports,
                          color: Colors.orange, size: screenWidth * 0.08),
                      title: isEditing
                          ? TextFormField(
                              controller: hobbyController,
                              decoration: const InputDecoration(
                                labelText: 'Hobby',
                                border: OutlineInputBorder(),
                              ),
                            )
                          : Text(hobbyController.text),
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
                  if (isEditing) {
                    saveProfile();
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  minimumSize: Size(screenWidth * 0.5, 50),
                ),
                child: Text(isEditing ? 'Save' : 'Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
