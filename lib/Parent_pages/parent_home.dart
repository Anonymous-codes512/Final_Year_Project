import 'package:final_year_project/Parent_pages/edit_child.dart';
import 'package:final_year_project/Parent_pages/kid_register.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentHome extends StatelessWidget {
  final String? userName;
  final String parentEmail;

  const ParentHome({
    this.userName,
    required this.parentEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF373E37),
        title: const Text(
          'Children Registered',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            // Top Section with greeting and add child button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFDE59),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFDE59).withOpacity(0.3),
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
                        color: Color(0xFF373E37),
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
                              AddChildScreen(parentEmail: parentEmail),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
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
            // Child Count Section using parent's document "children" field
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(parentEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const SizedBox();
                }
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                List children = data['children'] ?? [];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total Children Registered: ${children.length}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Child List Section reading from parent's "children" array
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(parentEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                        child: Text('No children data available.'));
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List children = data['children'] ?? [];

                  if (children.isEmpty) {
                    return const Center(
                      child: Text(
                        'No children data available.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      var child = children[index] as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF4B4848),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            child['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF373E37),
                            ),
                          ),
                          subtitle: Text(
                            'Age: ${child['age'] ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF373E37),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFF4B4848)),
                            onPressed: () {
                              // Navigate to the EditChildScreen with the child's data.
                              // Assumes each child object has a unique "childId".
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditChildScreen(
                                    childId: child['childId'],
                                    childName: child['name'] ?? 'No Name',
                                    childAge: (child['age'] != null)
                                        ? child['age'].toString()
                                        : 'Unknown',
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
