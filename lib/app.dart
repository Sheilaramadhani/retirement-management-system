// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:retirement_management_system/pages/splash_screen.dart';

class Rms extends StatelessWidget {
  Rms({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RMS',
      home: SplashScreen(),
    );
  }
}
