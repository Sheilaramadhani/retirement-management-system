// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:retirement_management_system/calculate/investmentcalculator.dart';
import 'package:retirement_management_system/expense/expense.dart';
import 'package:retirement_management_system/pages/advisory.dart';
import 'package:retirement_management_system/pages/investing.dart';
import 'package:retirement_management_system/saving/goal.dart';
import 'package:retirement_management_system/saving/loan.dart';
import 'package:retirement_management_system/saving/saving.dart';

class MyBodyUser extends StatelessWidget {
  const MyBodyUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container( // Wrap the Column with a Container
        width: MediaQuery.of(context).size.width, // Set the width to the screen's width
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'RETIREMENT MANAGEMENT SYSTEM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Your Tomorrow is Today',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 45,
            ),
            SizedBox(
              height: 45,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded( // Use Expanded to make buttons have equal sizes
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SavingsPlanManagementPage()),
                            );
                          },
                          child: Text('SAVING MANAGEMENT'),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded( // Use Expanded to make buttons have equal sizes
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ExpenseApp()),
                            );
                          },
                          child: Text('EXPENSES MANAGEMENT'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded( // Use Expanded to make buttons have equal sizes
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GoalTrackerScreen()),
                            );
                          },
                          child: Text('GOAL MANAGEMENT'),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded( // Use Expanded to make buttons have equal sizes
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MonthlyInvestmentCalculator()),
                            );
                          },
                          child: Text('INVESTMENT CALCULATOR'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded( // Use Expanded to make buttons have equal sizes
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoanManagementApp()),
                            );
                          },
                          child: Text('LOAN MANAGEMENT'),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded( // Use Expanded to make buttons have equal sizes
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdvisorPage()),
                            );
                          },
                          child: Text('FINANCIAL ADVISORS'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                ),
                onPressed: () {
                  // Navigate to the investment options page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvestmentFirmListPage()),
                  );
                },
                child: Text('View The Best Investment Options'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
