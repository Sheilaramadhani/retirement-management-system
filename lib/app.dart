import 'package:flutter/material.dart';
import 'package:retirement_management_system/pages/home.dart';

class Rms extends StatelessWidget {
  const Rms({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RMS',
      home: HomePage(),
    );
  }
}
