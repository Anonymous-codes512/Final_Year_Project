import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userId;
  final String name;
  final String gender;
  final String email;
  final String bio;
  final String qualification;
  final String speciality;
  final List<String> availableTimes;

  User({
    required this.userId,
    required this.name,
    required this.gender,
    required this.email,
    this.bio = '',
    this.qualification = '',
    this.speciality = '',
    this.availableTimes = const [],
  });

  // Convert a User object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'gender': gender,
      'email': email,
      'bio': bio,
      'qualification': qualification,
      'speciality': speciality,
      'availableTimes': availableTimes,
    };
  }

  // Create a User object from a Firestore map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      qualification: map['qualification'] ?? '',
      speciality: map['speciality'] ?? '',
      availableTimes: List<String>.from(map['availableTimes'] ?? []),
    );
  }

  // Create a User object from a Firestore document
  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromMap(doc.data() as Map<String, dynamic>);
  }
}
