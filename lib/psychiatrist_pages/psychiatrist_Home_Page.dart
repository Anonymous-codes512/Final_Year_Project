import 'package:final_year_project/Authentication/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PsychiatristHomePage extends StatelessWidget {
  final String userName;

  const PsychiatristHomePage({required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFDE59),
        title: const Text('Psychiatrist Dashboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            _logout(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorname', isEqualTo: userName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No appointments available.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var appointment =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String status = appointment['status'];
              Color statusColor = status == 'approved'
                  ? Colors.green
                  : status == 'rejected'
                      ? Colors.red
                      : Colors.orange;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundColor: statusColor,
                    child: Icon(
                      status == 'approved'
                          ? Icons.check
                          : status == 'rejected'
                              ? Icons.close
                              : Icons.hourglass_empty,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Appointment on ${appointment['day']} at ${appointment['time']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Patient: ${appointment['patientName'] ?? 'N/A'}'),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${status[0].toUpperCase()}${status.substring(1)}',
                        style: TextStyle(color: statusColor),
                      ),
                    ],
                  ),
                  trailing: status == 'pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              onPressed: () {
                                _updateAppointmentStatus(context,
                                    snapshot.data!.docs[index].id, 'approved');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                _updateAppointmentStatus(context,
                                    snapshot.data!.docs[index].id, 'rejected');
                              },
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to handle logout
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Handle logout error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  // Function to update the appointment status
  void _updateAppointmentStatus(
      BuildContext context, String documentId, String newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: Text(
            'Are you sure you want to mark this appointment as $newStatus?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(documentId)
                  .update({'status': newStatus});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  newStatus == 'approved' ? Colors.green : Colors.red,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
