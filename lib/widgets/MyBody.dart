// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:retirement_management_system/financial/reg2.dart';
import 'package:retirement_management_system/pages/investing.dart';
import 'package:retirement_management_system/pages/login_page.dart';

class MyBody extends StatelessWidget {
  const MyBody ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RETIREMENT MANAGEMENT SYSTEM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
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
          SizedBox(height: 45),
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
          SizedBox(height: 45),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'This feature assists you in planning and monitoring your savings. You can set savings goals, track your progress, and allocate funds to different savings categories. It helps you establish a savings strategy and provides visibility into your savings journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('SAVING MANAGEMENT'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'With this feature, you can efficiently manage your expenses and track your spending. It enables you to categorize your expenses, set budgets, and record your transactions. By analyzing your expenses, you can gain insights into your spending habits and make informed financial decisions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('EXPENSES MANAGEMENT'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'This feature focuses on managing your financial goals effectively. You can define your short-term and long-term goals, such as buying a house, saving for retirement, or funding education. The goal management feature helps you set milestones, track your progress, and make adjustments to your financial plans as needed.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('GOAL MANAGEMENT'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'This tool helps you calculate the wealth gain and expected returns for your monthly investment. You can get a rough estimate of the maturity amount for any monthly investment plan, based on a projected annual return rate and Period (Years).',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('INVESTMENT CALCULATOR'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'This feature helps you track and manage your loans effectively. It allows you to input details of your loans, such as the principal amount, interest rate, and loan term. You can monitor your loan progress, calculate repayment schedules, and stay organized with your loan payments.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('LOAN MANAGEMENT'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    Text(
                      'You deserve investing advice from a true partner. From your first investment through retirement, we are with you the whole way, providing the best financial advisors at an affordable price.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('FINANCIAL ADVISORS'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 45),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you a customer or advisor?'),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.black),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text('Customer',
                          style: TextStyle(color: Colors.orange,),),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.orange),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogiinPage()),
                            );
                          },
                          child: Text('Advisor',
                          style: TextStyle(color: Colors.orange,),),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  'GET STARTED',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
