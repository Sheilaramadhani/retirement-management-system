// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class ApeCalculator extends StatefulWidget {
  @override
  _ApeCalculatorState createState() => _ApeCalculatorState();
}

class _ApeCalculatorState extends State<ApeCalculator> {
  List<double> monthlyEarnings = [];
  double ape = 0;

  void calculateAPE() {
    double totalEarnings = 0;

    for (var earnings in monthlyEarnings) {
      totalEarnings += earnings;
    }

    setState(() {
      ape = totalEarnings / monthlyEarnings.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APE Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter Monthly Earnings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Earnings',
              ),
              onChanged: (value) {
                setState(() {
                  monthlyEarnings.add(double.tryParse(value) ?? 0);
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateAPE,
              child: Text('Calculate APE'),
            ),
            SizedBox(height: 16),
            Text(
              'APE: $ape',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

