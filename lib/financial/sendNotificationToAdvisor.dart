// ignore_for_file: prefer_const_declarations, avoid_print, file_names

import 'package:http/http.dart' as http;


void sendAppointmentRequest(String advisorDeviceToken) async {
  final url = 'http://your-node-server-url:3000/appointments';
  final body = {'advisorDeviceToken': advisorDeviceToken};

  final response = await http.post(Uri.parse(url), body: body);

  if (response.statusCode == 200) {
    print('Appointment request sent successfully');
  } else {
    print('Failed to send appointment request');
  }
}
