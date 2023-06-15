// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';

class RetirementPlanPage extends StatefulWidget {
  @override
  _RetirementPlanPageState createState() => _RetirementPlanPageState();
}

class _RetirementPlanPageState extends State<RetirementPlanPage> {
  late int currentAge;
  late int desiredRetirementAge;
  late double income;
  late double expectedMonthlyExpenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Retirement Plan'),
      ),
           body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Retirement Plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Current Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  currentAge = int.parse(value);
                },
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Desired Retirement Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  desiredRetirementAge = int.parse(value);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Income'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  income = double.parse(value);
                },
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Expected Monthly Expenses'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  expectedMonthlyExpenses = double.parse(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final retirementPlan = RetirementPlan(
                    currentAge: currentAge,
                    desiredRetirementAge: desiredRetirementAge,
                    income: income,
                    expectedMonthlyExpenses: expectedMonthlyExpenses,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RetirementPlanResultPage(
                          retirementPlan: retirementPlan),
                    ),
                  );
                },
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RetirementPlan {
  final int currentAge;
  final int desiredRetirementAge;
  final double income;
  final double expectedMonthlyExpenses;

  RetirementPlan({
    required this.currentAge,
    required this.desiredRetirementAge,
    required this.income,
    required this.expectedMonthlyExpenses,
  });
}

class RetirementPlanResultPage extends StatelessWidget {
  final RetirementPlan retirementPlan;

  RetirementPlanResultPage({required this.retirementPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retirement Plan Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Retirement Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Current Age: ${retirementPlan.currentAge}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Desired Retirement Age: ${retirementPlan.desiredRetirementAge}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Income: \$${retirementPlan.income.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Expected Monthly Expenses: \$${retirementPlan.expectedMonthlyExpenses.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
