import 'package:final_year_project/Parent_pages/edit_child.dart';
import 'package:final_year_project/Parent_pages/kid_register.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentHome extends StatelessWidget {
  final String userName;
  final String parentEmail;

  const ParentHome({
    required this.userName,
    required this.parentEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF373E37), // Dark shade for AppBar
        title: const Text(
          'Children Registered',
          style: TextStyle(color: Colors.white), // White title text
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5), // Off-white background color
        child: Column(
          children: [
            // Top Section
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFDE59), // #ffde59 (Yellow shade)
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFDE59).withOpacity(
                        0.3), // Adjust shadow to match yellow shade
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage('assets/avatar_placeholder.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Hello, $userName',
                      style: const TextStyle(
                        color: Color(0xFF373E37), // Dark greenish shade
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddChildScreen()), // Navigate to the AddChildScreen
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          const Color(0xFFFFDE59), // Yellow button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('+ Add Child'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Child List Section
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('parentEmail', isEqualTo: parentEmail)
                    .where('role', isEqualTo: 'child')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'No children data available.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var child = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(
                                0xFFFFDE59), // Yellow shade for icon background
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            child['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  Color(0xFF373E37), // Dark greenish text color
                            ),
                          ),
                          subtitle: Text(
                            'Age: ${child['age'] ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF373E37), // Dark greenish color
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit,
                                color:
                                    Color(0xFFFFDE59)), // Yellow shade for icon
                            onPressed: () {
                              // Navigate to the EditChildScreen with the child's data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditChildScreen(
                                    childId: snapshot.data!.docs[index].id,
                                    childName: child['name'] ?? 'No Name',
                                    childAge: (child['age'] != null)
                                        ? child['age'].toString()
                                        : 'Unknown', // Fixed here
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
