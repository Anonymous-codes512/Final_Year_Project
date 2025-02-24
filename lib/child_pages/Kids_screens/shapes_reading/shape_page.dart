import 'package:flutter/material.dart';

class ShapesPage extends StatelessWidget {
  final List<Map<String, String>> shapes = [
    {'image': 'assets/shapes/shapes_all/circle_shape.png', 'name': 'Circle'},
    {'image': 'assets/shapes/shapes_all/square_shape.png', 'name': 'Square'},
    {'image': 'assets/shapes/shapes_all/diamond_shape.png', 'name': 'Diamond'},
    {
      'image': 'assets/shapes/shapes_all/rectangle_shape.png',
      'name': 'Rectangle'
    },
    {'image': 'assets/shapes/shapes_all/star_shape.png', 'name': 'Star'},
    {'image': 'assets/shapes/shapes_all/heart_shape.png', 'name': 'Heart'},
    {
      'image': 'assets/shapes/shapes_all/triangle_shape.png',
      'name': 'Triangle'
    },
    {
      'image': 'assets/shapes/shapes_all/semicircle_shape.png',
      'name': 'Semicircle'
    },
    {'image': 'assets/shapes/shapes_all/oval_shape.png', 'name': 'Oval'},
    {
      'image': 'assets/shapes/shapes_all/quadrilateral_shape.png',
      'name': 'Quadrilateral'
    },
    {
      'image': 'assets/shapes/shapes_all/pentagon_shape.png',
      'name': 'Pentagon'
    },
    {
      'image': 'assets/shapes/shapes_all/heptagon_shape.png',
      'name': 'Heptagon'
    },
    {'image': 'assets/shapes/shapes_all/hexagon_shape.png', 'name': 'Hexagon'},
    {'image': 'assets/shapes/shapes_all/octagon_shape.png', 'name': 'Octagon'},
  ];

  ShapesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shapes'),
        backgroundColor: Colors.teal, // Set a custom AppBar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: shapes.map((shape) {
                return Container(
                  width: screenWidth, // Ensures the container takes full width
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12, // Lightened shadow color
                        blurRadius: 5, // Reduced blur radius
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Image container with rounded corners and shadow
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          shape['image']!,
                          width:
                              screenWidth, // Makes the image width fill the container
                          fit: BoxFit
                              .cover, // Ensures the image covers the container fully
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Shape name below image
                      Text(
                        shape['name']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900, // Text color
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
