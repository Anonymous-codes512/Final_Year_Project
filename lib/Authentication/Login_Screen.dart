import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Auth_Service/Auth_service_Screen.dart';
import '../Parent_pages/Parent_home_screen.dart';
import '../child_pages/First_page.dart';
import '../psychiatrist_pages/psychiatrist_Home_Page.dart';
import 'Forget_password_page.dart';
import 'Registration_Screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String _errorMessage = '';
  bool _obscurePassword = true;
  String? _selectedRole;
  final bool _isLoading = false;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_selectedRole == null) {
      setState(() {
        _errorMessage = 'Please select a role.';
      });
      return;
    }

    try {
      User? user = await _authService.loginUser(email, password);
      if (user == null) {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        setState(() {
          _errorMessage = 'User not found in the database.';
        });
        return;
      }

      final Map<String, dynamic>? userData =
          userDoc.data() as Map<String, dynamic>?;

      if (userData == null ||
          !userData.containsKey('role') ||
          (!userData.containsKey('username') &&
              !userData.containsKey('name'))) {
        setState(() {
          _errorMessage = 'Incomplete user data. Please contact support.';
        });
        return;
      }

      // Convert age
      final age = userData['age'] is int
          ? userData['age'] as int
          : int.tryParse(userData['age']?.toString() ?? '') ?? 0;

      String role = userData['role'] as String;
      String username = userData['username'] ?? userData['name'] ?? '';

      String parentId = userData['parentId'] ?? '';
      String doctorId = userData['doctorId'] ?? '';

      if (role.toLowerCase() != _selectedRole!.toLowerCase()) {
        setState(() {
          _errorMessage = 'Role mismatch. Please select the correct role.';
        });
        return;
      }

      switch (role.toLowerCase()) {
        case 'parent':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ParentHomeScreen(
                userName: username,
                parentEmail: email,
              ),
            ),
          );
          break;
        case 'child':
          final String uid = user.uid;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChildHomePage(
                userName: username,
                userId: uid,
              ),
            ),
          );
          break;
        case 'psychiatrist':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PsychiatristHomePage(
                userName: username,
              ),
            ),
          );
          break;
        default:
          setState(() {
            _errorMessage = 'Unknown role. Please contact support.';
          });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
      });
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFDFAF7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/login_picture.png',
                      width: 250, height: 300),
                  const SizedBox(width: 2),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFffde59),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Log in to continue to your account',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Wrap the Row with SingleChildScrollView to avoid overflow
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<String>(
                            value: 'Parent',
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                          const Text('Parent'),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: 'Child',
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                          const Text('Child'),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: 'Psychiatrist',
                            groupValue: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                          const Text('Psychiatrist'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xFFffde59)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xFFffde59)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF000000),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forget Password",
                    style: TextStyle(color: Color(0xFFffde59), fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(screenWidth * 0.8, 50),
                        backgroundColor: const Color(0xFFffde59),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Color(0xFFffde59), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
