import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all available doctors
  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    try {
      final querySnapshot = await _firestore.collection('doctors').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Failed to fetch doctors: $e');
      rethrow;
    }
  }

  // Add a new appointment request
  Future<void> createAppointmentRequest(
      String parentId, String doctorId, String day, String time) async {
    try {
      // Check if the selected doctor is available
      final doctorDoc =
          await _firestore.collection('doctors').doc(doctorId).get();
      if (!doctorDoc.exists) {
        print('Doctor not found.');
        return;
      }

      // Create the appointment request
      await _firestore.collection('appointments').add({
        'parentId': parentId,
        'doctorId': doctorId,
        'day': day,
        'time': time,
        'status': 'pending', // Default status is 'pending'
      });

      print('Appointment request sent to doctor $doctorId for approval!');
    } catch (e) {
      print('Failed to create appointment request: $e');
      rethrow;
    }
  }

  // Fetch appointments for a specific parent
  Future<List<Map<String, dynamic>>> getAppointmentsForParent(
      String parentId) async {
    try {
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('parentId', isEqualTo: parentId)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Failed to fetch appointments for parent: $e');
      rethrow;
    }
  }

  // Fetch appointments for a specific doctor
  Future<List<Map<String, dynamic>>> getAppointmentsForDoctor(
      String doctorId) async {
    try {
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Failed to fetch appointments for doctor: $e');
      rethrow;
    }
  }

  // Update appointment status (e.g., to confirm or reject)
  Future<void> updateAppointmentStatus(
      String appointmentId, String status) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
      });
      print('Appointment status updated to $status');
    } catch (e) {
      print('Failed to update appointment status: $e');
      rethrow;
    }
  }
}
