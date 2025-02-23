import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditChildScreen extends StatelessWidget {
  final String childId;
  final String childName;
  final String childAge;

  const EditChildScreen({
    required this.childId,
    required this.childName,
    required this.childAge,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: childName);
    final ageController = TextEditingController(text: childAge);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Child Profile'),
        backgroundColor: const Color(0xFF373E37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update child profile in Firestore
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(childId)
                    .update({
                  'name': nameController.text,
                  'age': ageController.text,
                }).then((_) {
                  // Navigate back after updating
                  Navigator.pop(context);
                });
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
