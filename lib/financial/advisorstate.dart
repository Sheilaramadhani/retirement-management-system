// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api, prefer_const_declarations, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AppointmentRecordsPage extends StatefulWidget {
  final String advisorId;

  const AppointmentRecordsPage({required this.advisorId});

  @override
  _AppointmentRecordsPageState createState() => _AppointmentRecordsPageState();
}

class _AppointmentRecordsPageState extends State<AppointmentRecordsPage> {
  String message = '';

  @override
  void initState() {
    super.initState();
    // Listen to messages from the Node.js server
    _startListening();
  }

  void _startListening() async {
    final serverUrl = 'http://localhost:3000'; // Replace with your server URL

    try {
      http.Response response = await http.get(Uri.parse('$serverUrl/messages'));
      if (response.statusCode == 200) {
        setState(() {
          message = response.body;
        });
      }
    } catch (e) {
      print('Error occurred while fetching messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Appointment Records'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('advisorId', isEqualTo: widget.advisorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> appointments =
                snapshot.data!.docs;
            int numberOfAppointments = appointments.length;
            return ListView.builder(
              itemCount: numberOfAppointments + 1, // Add an extra item for the notification message
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Display the notification message
                  return ListTile(
                    title: Text('Notification'),
                    subtitle: Text(message),
                  );
                }

                Map<String, dynamic>? appointmentData =
                    appointments[index - 1].data();
                String userName = appointmentData['userName'] ?? '';
                Timestamp appointmentTime = appointmentData['appointmentTime'];

                return ListTile(
                  title: Text(userName),
                  subtitle: Text(appointmentTime.toDate().toString()),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
