import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        color: Colors.pink[50],
        child: const Center(
          child: Text('Settings Page', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
