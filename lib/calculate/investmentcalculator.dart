// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyInvestmentCalculator extends StatefulWidget {
  @override
  _MonthlyInvestmentCalculatorState createState() =>
      _MonthlyInvestmentCalculatorState();
}

class _MonthlyInvestmentCalculatorState
    extends State<MonthlyInvestmentCalculator> {
  double monthlyInvestment = 0;
  double expectedAnnualReturn = 0;
  int periodYears = 0;
  double totalInvestment = 0;
  double totalReturns = 0;
  double finalAmount = 0;

  void calculateInvestment() {
    totalInvestment = monthlyInvestment * periodYears * 12;
    totalReturns =
        totalInvestment * (expectedAnnualReturn / 100); // assuming simple interest
    finalAmount = totalInvestment + totalReturns;

    // Store the information in Firestore
    FirebaseFirestore.instance.collection('investments').add({
      'monthlyInvestment': monthlyInvestment,
      'expectedAnnualReturn': expectedAnnualReturn,
      'periodYears': periodYears,
      'totalInvestment': totalInvestment,
      'totalReturns': totalReturns,
      'finalAmount': finalAmount,
    });

    setState(() {});
  }

  String formatAmount(double amount) {
    return 'Tsh ${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Investment Calculator'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monthly Investment',
              ),
              onChanged: (value) {
                setState(() {
                  monthlyInvestment = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Expected Annual Return (%)',
              ),
              onChanged: (value) {
                setState(() {
                  expectedAnnualReturn = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Period (years)',
              ),
              onChanged: (value) {
                setState(() {
                  periodYears = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
              onPressed: calculateInvestment,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Total Investment: ${formatAmount(totalInvestment)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Returns: ${formatAmount(totalReturns)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Final Amount: ${formatAmount(finalAmount)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25.0),
            Text(
              'Investment History',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.0),
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('investments').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final investments = snapshot.data!.docs;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Monthly Investment')),
            DataColumn(label: Text('Expected Annual Return')),
            DataColumn(label: Text('Period (Years)')),
            DataColumn(label: Text('Total Investment')),
            DataColumn(label: Text('Total Returns')),
            DataColumn(label: Text('Final Amount')),
          ],
          rows: investments.map((investment) {
            final monthlyInvestment = investment['monthlyInvestment'];
            final expectedAnnualReturn = investment['expectedAnnualReturn'];
            final periodYears = investment['periodYears'];
            final totalInvestment = investment['totalInvestment'];
            final totalReturns = investment['totalReturns'];
            final finalAmount = investment['finalAmount'];
            return DataRow(
              cells: [
                DataCell(Text(formatAmount(monthlyInvestment))),
                DataCell(Text(expectedAnnualReturn.toString())),
                DataCell(Text(periodYears.toString())),
                DataCell(Text(formatAmount(totalInvestment))),
                DataCell(Text(formatAmount(totalReturns))),
                DataCell(Text(formatAmount(finalAmount))),
              ],
            );
          }).toList(),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  },
),
          ],
        ),
      ),
    );
  }
}
