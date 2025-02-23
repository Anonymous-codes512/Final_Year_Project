import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Utility function to show toast/snackbar messages
  void _showMessage(String message, {Color color = Colors.yellow}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to send the password reset email
  Future<void> _sendPasswordResetEmail() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email.', color: Colors.red);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage(
          'We have sent you an email to recover your password. Please check your inbox.');
    } catch (e) {
      _showMessage('Error: ${e.toString()}', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password',
            style: TextStyle(color: Color(0xFF000000))),
        backgroundColor: const Color(0xFFffde59),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email, color: Color(0xFFffde59)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFffde59),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Send Reset Link',
                style: TextStyle(fontSize: 16, color: Color(0xFF000000)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
