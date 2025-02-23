import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationScreen extends StatelessWidget {
  // List of clickable items with titles and URLs
  final List<Map<String, String>> educationItems = [
    {
      'title': 'Dyscalculia Information Centre',
      'url': 'https://www.dyscalculia.me.uk'
    },
    {'title': 'Dyscalculia Blog', 'url': 'https://dyscalculia-blog.com'},
    {
      'title': 'About Dyscalculia',
      'url': 'https://www.bdadyslexia.org.uk/dyscalculia'
    },
    {
      'title': 'Explore Dyscalculia',
      'url': 'https://my.clevelandclinic.org/health/diseases/23949-dyscalculia'
    },
    {
      'title': 'What is dyscalculia?',
      'url': 'https://www.understood.org/en/articles/what-is-dyscalculia'
    },
  ];

  EducationScreen({super.key});

  // Function to handle URL opening
  void _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not open URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Education Resources',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF373E37), // Dark shade for AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F7), // Off-white background
      body: ListView.builder(
        itemCount: educationItems.length,
        itemBuilder: (context, index) {
          final item = educationItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFDE59), // Yellow background
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.link,
                    color: Color(0xFF373E37)), // Dark icon
                title: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF373E37), // Dark text
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward,
                    color: Color(0xFF373E37)), // Dark trailing icon
                onTap: () {
                  _openUrl(item['url']!);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
