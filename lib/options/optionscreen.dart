// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class InvestingOptionsScreen extends StatelessWidget {
  final int age;
  final int income;
  final String goal;

  InvestingOptionsScreen({
    required this.age,
    required this.income,
    required this.goal,
  });

  List<String> getInvestmentOptions() {
    if (age < 30) {
      // Suggest investment options for individuals under 30
      return [
        'Savings Account',
        'Fixed Deposit',
        'Mutual Funds',
        'Stock Market',
        'Real Estate',
        'Agriculture',
        'Small Business',
        'Education and Skills Development',
      ];
    } else if (age >= 30 && age < 50) {
      // Suggest investment options for individuals between 30 and 50
      return [
        'Retirement Savings Accounts',
        'Government Bonds',
        'Real Estate',
        'Unit Trusts',
        'Fixed Deposit Accounts',
        'Stock Market',
        'Peer-to-Peer Lending',
        'Small Business or Start-ups',
        'Education and Skill Development',
      ];
    } else {
      // Suggest investment options for individuals over 50
      return [
        'Fixed Income Investments',
        'Retirement Annuities',
        'Mutual Funds',
        'Dividend-Paying Stocks',
        'Business Ventures',
        'Voluntary Pension Contributions',
        'Estate Planning',
      ];
    }
  }

  List<String> getInvestmentOrganizations() {
    return [
      'Bank of Tanzania',
      'CRDB Bank',
      'National Microfinance Bank',
      'Stanbic Bank',
      'Exim Bank',
      'Standard Chartered Bank',
      'Barclays Bank',
      'Amana Bank',
      'Akiba Commercial Bank',
      'Azania Bank',
      'NBC Bank',
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<String> investmentOptions = getInvestmentOptions();
    List<String> investmentOrganizations = getInvestmentOrganizations();

    return Scaffold(
      appBar: AppBar(
        title: Text('Investing Options'),
      ),
        body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Age: $age',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Income: $income',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Goal: $goal',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Investment Options:',
              style: TextStyle(fontSize: 24),
            ),
            Column(
              children: investmentOptions
                  .map(
                    (option) => GestureDetector(
                      onTap: () {
                        // Navigate to another class or page here
                      },
                      child: InvestmentOptionWidget(
                        title: option,
                        description: 'This is the description of $option.',
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Investment Organizations:',
              style: TextStyle(fontSize: 24),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: investmentOrganizations
                  .map(
                    (organization) => GestureDetector(
                      onTap: () {
                        // Navigate to another class or page here
                      },
                      child: InvestmentOptionWidget(
                        title: organization,
                        description: 'This is the description of $organization.',
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestmentOptionWidget extends StatelessWidget {
  final String title;
  final String description;

  InvestmentOptionWidget({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(description),
        ],
      ),
    );
  }
}
