// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:retirement_management_system/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:retirement_management_system/firebase_options.dart';

void main() async {
  // Initialize Firebase app
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
    // FirebaseOptions(
    //   appId: '1:58959430568:android:c1e32699446731b1ced39d',
    //   apiKey: 'AIzaSyCpkwAFui0PciVorZ9zOpENs3i-mVsLGK4',
    //   projectId: ' retirement-management-system',
    //   messagingSenderId: '58959430568',
    // ),
  );

  runApp(Rms());
}
