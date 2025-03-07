import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileEditScreen extends StatefulWidget {
  final String kidName;
  final String avatar;

  const ProfileEditScreen(
      {super.key, required this.kidName, required this.avatar});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool isLoading = true;

  String name = '';
  String hobby = '';
  String favoriteSubject = '';
  String selectedGender = 'Male';
  String selectedAvatar = 'assets/kids_profile.jpeg';

  final nameController = TextEditingController();
  final hobbyController = TextEditingController();
  final favoriteSubjectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference profileDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids_profiles')
          .doc(widget.kidName);

      DocumentSnapshot profileSnapshot = await profileDoc.get();

      if (profileSnapshot.exists) {
        var profileData = profileSnapshot.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = profileData['name'] ?? widget.kidName;
          hobbyController.text = profileData['hobby'] ?? 'Hobby';
          favoriteSubjectController.text =
              profileData['favorite_subject'] ?? 'Favorite Subject';
          selectedGender = profileData['gender'] ?? 'Male';
          selectedAvatar = profileData['avatar'] ?? widget.avatar;
          isLoading = false;
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
          .collection('kids_profiles')
          .doc(widget.kidName);

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

      // After saving, navigate back to view profile screen
      Navigator.pop(context);
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
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                String avatarUrl = 'assets/kids/avatars/avatar_$index.png';
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

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Home'),
        backgroundColor: const Color(0xFFF9D77E),
      ),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
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
                      title: TextFormField(
                        controller: favoriteSubjectController,
                        decoration: const InputDecoration(
                          labelText: 'Favorite Subject',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.person,
                          color: Colors.green, size: screenWidth * 0.08),
                      title: const Text('Gender'),
                      trailing: DropdownButton<String>(
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.sports_esports,
                          color: Colors.orange, size: screenWidth * 0.08),
                      title: TextFormField(
                        controller: hobbyController,
                        decoration: const InputDecoration(
                          labelText: 'Hobby',
                          border: OutlineInputBorder(),
                        ),
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
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  minimumSize: Size(screenWidth * 0.5, 50),
                ),
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
