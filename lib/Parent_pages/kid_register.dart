import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddChildScreen extends StatefulWidget {
  final String? childId; // Child ID for editing purposes (null if creating new)
  final String? childName;
  final int? childAge;
  final String? childEmail;

  const AddChildScreen({
    super.key,
    this.childId,
    this.childName,
    this.childAge,
    this.childEmail,
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
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.childId != null) {
      // Set the form with existing data if we're in edit mode
      _isEditMode = true;
      _nameController.text = widget.childName ?? '';
      _ageController.text = widget.childAge?.toString() ?? '';
      _emailController.text = widget.childEmail ?? '';
    }
  }

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

        final parentEmail = parentUser.email;

        if (_isEditMode) {
          // Update existing child data
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.childId)
              .update({
            'name': _nameController.text.trim(),
            'age': int.tryParse(_ageController.text.trim()) ?? 0,
            'email': _emailController.text.trim(),
            'parentEmail': parentEmail,
            'role': 'child',
          });

          setState(() {
            _errorMessage = 'Child data updated successfully.';
          });

          // Navigate back after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          // Create Firebase authentication account for the child
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Send email verification for the child
          await userCredential.user!.sendEmailVerification();

          // Save child data to Firestore under 'users' collection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _nameController.text.trim(),
            'age': int.tryParse(_ageController.text.trim()) ?? 0,
            'email': _emailController.text.trim(),
            'parentEmail': parentEmail,
            'role': 'child',
          });

          setState(() {
            _errorMessage =
                'Child registered successfully. Please verify the email.';
          });

          // Check if the child’s email is verified
          if (!userCredential.user!.emailVerified) {
            setState(() {
              _errorMessage =
                  'Please verify your child\'s email before proceeding.';
            });
            return;
          }

          // Navigate back after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        }
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

  void _deleteChild() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.childId)
          .delete();

      // If you want to also delete the child’s authentication, you can uncomment the following:
      // await FirebaseAuth.instance.currentUser?.delete();

      setState(() {
        _errorMessage = 'Child data deleted successfully.';
      });

      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while deleting the child data.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Child' : 'Add Child'),
        backgroundColor: const Color(0xFFffde59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
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
              // Password Field (only for adding a child)
              if (!_isEditMode)
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
                        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
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
                child: Text(_isEditMode ? 'Update Child' : 'Register Child'),
              ),
              const SizedBox(height: 16),
              // Delete Button (only in edit mode)
              if (_isEditMode)
                ElevatedButton(
                  onPressed: _deleteChild,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Child'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
