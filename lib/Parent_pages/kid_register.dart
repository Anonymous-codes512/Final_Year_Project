import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChildScreen extends StatefulWidget {
  final String parentEmail; // Parent email from the previous screen

  const AddChildScreen({
    super.key,
    required this.parentEmail,
  });

  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _isPasswordVisible = false;
  String _errorMessage = '';

  void _registerChild() async {
    if (_formKey.currentState!.validate()) {
      try {
        final parentUser = FirebaseAuth.instance.currentUser;
        if (parentUser == null) {
          setState(() {
            _errorMessage = 'Parent must be logged in to add a child.';
          });
          return;
        }

        final String parentEmail = widget.parentEmail;

        // Create a Firebase auth account for the child.
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Send email verification for the child.
        await userCredential.user!.sendEmailVerification();

        // Update parent's document by appending the new child to the "children" array.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(parentEmail)
            .set({
          'children': FieldValue.arrayUnion([
            {
              'childId': userCredential.user!.uid,
              'name': _nameController.text.trim(),
              'age': int.tryParse(_ageController.text.trim()) ?? 0,
              'email': _emailController.text.trim(),
              'role': 'child',
            }
          ])
        }, SetOptions(merge: true));

        setState(() {
          _errorMessage =
              'Child registered successfully. Please verify the email.';
        });

        // Check if the child's email is verified.
        if (!userCredential.user!.emailVerified) {
          setState(() {
            _errorMessage =
                'Please verify your child\'s email before proceeding.';
          });
          return;
        }

        // Redirect back to the previous screen after a short delay.
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            _errorMessage = 'This email is already registered.';
          } else if (e.code == 'invalid-email') {
            _errorMessage = 'The email address is not valid.';
          } else if (e.code == 'weak-password') {
            _errorMessage = 'The password is too weak.';
          } else {
            _errorMessage = 'Registration failed: ${e.message}';
          }
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Child'),
        backgroundColor: const Color(0xFFffde59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the count of registered children by reading parent's document.
            // StreamBuilder<DocumentSnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('users')
            //       .doc(widget.parentEmail)
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData && snapshot.data!.exists) {
            //       Map<String, dynamic> data =
            //           snapshot.data!.data() as Map<String, dynamic>;
            //       List children = data['children'] ?? [];
            //       return Text(
            //         'Total Children Registered: ${children.length}',
            //         style: const TextStyle(
            //             fontSize: 16, fontWeight: FontWeight.bold),
            //       );
            //     }
            //     return const CircularProgressIndicator();
            //   },
            // ),
            // const SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Age Field
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the age';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.endsWith('@gmail.com')) {
                          return 'Only Gmail addresses are accepted.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8 ||
                            !RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                .hasMatch(value)) {
                          return 'Password must be at least 8 characters and include a special character.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Register Button
                    ElevatedButton(
                      onPressed: _registerChild,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFFffde59),
                      ),
                      child: const Text('Register Child'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
