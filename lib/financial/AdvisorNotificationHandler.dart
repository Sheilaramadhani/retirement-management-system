// ignore_for_file: prefer_const_constructors, unnecessary_cast, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentRecordsPage extends StatelessWidget {
  final String advisorId;

  const AppointmentRecordsPage({required this.advisorId});

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
            .where('advisorId', isEqualTo: advisorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Process snapshot data
          final appointmentDocs = snapshot.data!.docs;
          final appointments =
              appointmentDocs.map((doc) => doc.data()).toList();

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index] as Map<String, dynamic>;

              return ListTile(
                title: Text('User: ${appointment['userName']}'),
                subtitle: Text('Time: ${appointment['appointmentTime'].toDate().toString()}'),
                // Add additional appointment details as needed
              );
            },
          );
        },
      ),
    );
  }
}
