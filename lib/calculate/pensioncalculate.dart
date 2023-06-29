// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:retirement_management_system/options/retirementplan.dart';

class MonthsServedCalculator extends StatefulWidget {
  @override
  _MonthsServedCalculatorState createState() => _MonthsServedCalculatorState();
}

class _MonthsServedCalculatorState extends State<MonthsServedCalculator> {
  late int startYear;
  late int expectedRetirementYear;
  int monthsServed = 0;
  late double ape;
  double fullPension = 0;
  double commutedPension = 0;
  double monthlyPension = 0;
  bool isVoluntary = false;

  void calculateMonthsServed() {
    DateTime startDate = DateTime(startYear);
    DateTime retirementDate = DateTime(expectedRetirementYear);

    monthsServed = ((retirementDate.year - startDate.year) * 12) +
        (retirementDate.month - startDate.month);

    setState(() {});
  }

  void calculatePensions() {
    if (monthsServed < 180) {
      monthlyPension = (1 / 580) * monthsServed * ape * (1 / 12) * 0.67;
      commutedPension = 0;
      fullPension = 0;
    }
    if (isVoluntary) {
      commutedPension =
          (1 / 580) * monthsServed * ape * 12.5 * 0.33; // Voluntary retirement when the age is 55
      fullPension = 0;
      monthlyPension = 0;
    } else {
      commutedPension = 0;
      fullPension = (1 / 580) * monthsServed * ape; // 60
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Know Your Pension'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Retirement Type:'),
                SizedBox(width: 10),
                DropdownButton<bool>(
                  value: isVoluntary,
                  items: [
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Compulsory'),
                    ),
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Voluntary'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isVoluntary = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: () {
                calculateMonthsServed();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('APE Calculator'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Average Pensionable Earnings (APE)',
                            ),
                            onChanged: (value) {
                              setState(() {
                                ape = double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                            ),
                            onPressed: calculatePensions,
                            child: Text('Calculate Pensions'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Calculate',
              ),
            ),
            SizedBox(height: 40),
            DataTable(
              columns: [
                DataColumn(label: Text('Pension Type')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('Number of Months Served')),
                  DataCell(Text('$monthsServed')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Full Pension (Tshs)')),
                  DataCell(Text('$fullPension')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Commuted Pension (Tshs)')),
                  DataCell(Text('$commutedPension')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Monthly Pension (Tshs)')),
                  DataCell(Text('$monthlyPension')),
                ]),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: () {
                // Navigate to the investment options page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RetirementPlanPage(),
                  ),
                );
              },
              child: Text('Explore The Best Investment Options'),
            ),
          ],
        ),
      ),
    );
  }
}
