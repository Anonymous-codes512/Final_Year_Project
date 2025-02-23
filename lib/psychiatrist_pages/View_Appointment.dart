import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  final String doctorId;

  const DoctorAppointmentScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: StreamBuilder(
        stream: firestore
            .collection('appointments')
            .where('doctorId',
                isEqualTo:
                    doctorId) // Fetch appointments for the specific doctor
            .where('status',
                isEqualTo: 'pending') // Only show pending appointments
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending appointments."));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                title: Text(
                    "Day: ${appointment['day']} | Time: ${appointment['time']}"),
                subtitle: Text("Parent ID: ${appointment['parentId']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Color(0xFFFFDE59)),
                      onPressed: () async {
                        // Accept appointment
                        await firestore
                            .collection('appointments')
                            .doc(appointment.id)
                            .update({
                          'status': 'accepted',
                          'doctorId': doctorId,
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        // Reject appointment
                        await firestore
                            .collection('appointments')
                            .doc(appointment.id)
                            .update({'status': 'rejected'});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
