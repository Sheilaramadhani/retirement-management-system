// ignore_for_file: prefer_const_declarations, avoid_print, file_names

import 'package:http/http.dart' as http;

void saveDeviceToken(String token) async {
  final url = 'https://your-api-endpoint.com/save-token'; // Replace with your API endpoint
  final response = await http.post(Uri.parse(url), body: {'token': token});
  
  if (response.statusCode == 200) {
    print('Device token saved successfully');
  } else {
    print('Failed to save device token');
  }
}
