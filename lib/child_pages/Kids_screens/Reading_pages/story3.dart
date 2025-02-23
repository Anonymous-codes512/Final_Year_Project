import 'package:flutter/material.dart';

class Story3Page extends StatelessWidget {
  // Replace this with your list of images
  final List<Map<String, String>> storyData = [
    {'image': 'assets/tables/table_1_2.png'},
    {'image': 'assets/tables/table_3_4.png'},
    {'image': 'assets/tables/table_5_6.png'},
    {'image': 'assets/tables/table_7_8.png'},
    {'image': 'assets/tables/table_9_and_10.png'},
    {'image': 'assets/tables/table_11_and_12.png'},
  ];

  Story3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
        backgroundColor: const Color(0xFFffde59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: storyData.length,
          itemBuilder: (context, index) {
            final storyItem = storyData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Image.asset(
                    storyItem['image']!,
                    height: 400, // Adjust height for a more rectangular shape
                    width: double.infinity,
                    fit: BoxFit.cover, // Ensures image fills the space
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
