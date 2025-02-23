import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookAppointment extends StatefulWidget {
  final String parentEmail;

  const BookAppointment({required this.parentEmail, super.key});

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  String? selectedDoctor;
  String? selectedDay;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F7F7), // Set off-white background color
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: const Color(0xFFFFDE59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Select Doctor:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'Psychiatrist')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    'No doctors available.',
                    style: TextStyle(color: Colors.grey),
                  );
                }

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDoctor = data['username'];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedDoctor == data['username']
                              ? const Color(0xFFFFDE59).withOpacity(0.9)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF373E37)),
                        ),
                        child: Text(
                          data['username'] ?? 'Unknown',
                          style: TextStyle(
                            color: selectedDoctor == data['username']
                                ? Colors.white
                                : const Color(0xFF373E37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Day:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                  .map((day) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedDay == day
                          ? const Color(0xFFFFDE59).withOpacity(0.9)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF373E37)),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: selectedDay == day
                            ? Colors.white
                            : const Color(0xFF373E37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (selectedDay != null) ...[
              const Text(
                'Select Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  '9:00 AM',
                  '10:00 AM',
                  '11:00 AM',
                  '2:00 PM',
                  '4:00 PM'
                ].map((time) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedTime == time
                            ? const Color(0xFFFFDE59).withOpacity(0.9)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF373E37)),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: selectedTime == time
                              ? Colors.white
                              : const Color(0xFF373E37),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: selectedDoctor != null &&
                      selectedDay != null &&
                      selectedTime != null
                  ? () async {
                      try {
                        var existingAppointment = await FirebaseFirestore
                            .instance
                            .collection('appointments')
                            .where('doctorname', isEqualTo: selectedDoctor)
                            .where('day', isEqualTo: selectedDay)
                            .where('time', isEqualTo: selectedTime)
                            .get();

                        if (existingAppointment.docs.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Appointment at this time is already booked.')),
                          );
                        } else {
                          await FirebaseFirestore.instance
                              .collection('appointments')
                              .add({
                            'doctorname': selectedDoctor,
                            'day': selectedDay,
                            'time': selectedTime,
                            'status': 'pending',
                            'parentEmail': widget.parentEmail,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Appointment request sent successfully!')),
                          );
                          setState(() {
                            selectedDoctor = null;
                            selectedDay = null;
                            selectedTime = null;
                          });
                        }
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $error')),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF373E37),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Submit Request',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
