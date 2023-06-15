// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class LogoutPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // Redirect to login page or any other desired page
      Navigator.pushReplacementNamed(context as BuildContext, '/LoginPage');
    } catch (e) {
      print('Error occurred during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: _logout,
        ),
      ),
    );
  }
}


