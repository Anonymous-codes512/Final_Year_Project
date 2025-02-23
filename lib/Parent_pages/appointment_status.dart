import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentStatus extends StatelessWidget {
  final String parentEmail;

  const AppointmentStatus({required this.parentEmail, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Set off-white background color
      appBar: AppBar(
        title: const Text(
          'Appointment Status',
          style: TextStyle(color: Colors.white), // White text color for AppBar
        ),
        backgroundColor: Colors.black, // Full black AppBar
        iconTheme: const IconThemeData(
          color: Colors.white, // Set back icon color to white
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('parentEmail', isEqualTo: parentEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No appointments found.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var appointment = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String status = appointment['status'] ?? 'Unknown';
              Color statusColor;
              Color containerColor;

              switch (status.toLowerCase()) {
                case 'accepted':
                  statusColor = Colors.black;
                  containerColor = const Color(0xFFFFDE59);
                  break;
                case 'pending':
                  statusColor = Colors.black;
                  containerColor = const Color(0xFFFFDE59);
                  break;
                case 'rejected':
                  statusColor = Colors.white;
                  containerColor = const Color(0xFF373E37);
                  break;
                default:
                  statusColor = Colors.grey;
                  containerColor = Colors.grey.shade200;
              }

              return Card(
                color: containerColor,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundColor: statusColor,
                    child: Icon(
                      status.toLowerCase() == 'accepted'
                          ? Icons.check
                          : status.toLowerCase() == 'rejected'
                          ? Icons.close
                          : Icons.hourglass_empty,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Day: ${appointment['day'] ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Time: ${appointment['time'] ?? 'N/A'}'),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${status[0].toUpperCase()}${status.substring(1)}',
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
