// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';

class MonthServedCalculator extends StatefulWidget {
  @override
  _MonthServedCalculatorState createState() => _MonthServedCalculatorState();
}

class _MonthServedCalculatorState extends State<MonthServedCalculator> {
  late int startYear;
  late int expectedRetirementYear;
  late int monthsServed;

  void calculateMonthsServed() {
    DateTime startDate = DateTime(startYear);
    DateTime retirementDate = DateTime(expectedRetirementYear);

    monthsServed = ((retirementDate.year - startDate.year) * 12) +
        (retirementDate.month - startDate.month);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Months Served Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Start Year of Employment',
              ),
              onChanged: (value) {
                setState(() {
                  startYear = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Expected Year of Retirement',
              ),
              onChanged: (value) {
                setState(() {
                  expectedRetirementYear = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateMonthsServed,
              child: Text('Calculate'),
            ),
            SizedBox(height: 16),
            Text(
              'Months Served: ${monthsServed}',
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
