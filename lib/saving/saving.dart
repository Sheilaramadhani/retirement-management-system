// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, unused_local_variable

import 'package:flutter/material.dart';

class SavingsPlanManagementPage extends StatefulWidget {
  const SavingsPlanManagementPage({Key? key}) : super(key: key);

  @override
  _SavingsPlanManagementPageState createState() =>
      _SavingsPlanManagementPageState();
}

class _SavingsPlanManagementPageState extends State<SavingsPlanManagementPage> {
  TextEditingController goalController = TextEditingController();
  TextEditingController monthlyContributionController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  double totalSavings = 0.0;
  double advisedMonthlyContribution = 0.0;
  int suggestedDuration = 0;

  @override
  void dispose() {
    goalController.dispose();
    monthlyContributionController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void calculateTotalSavings() {
    double goalAmount = double.tryParse(goalController.text) ?? 0.0;
    double monthlyContribution =
        double.tryParse(monthlyContributionController.text) ?? 0.0;
    int duration = int.tryParse(durationController.text) ?? 0;

    double total = monthlyContribution * duration;
    double remainingAmount = goalAmount - total;

    if (remainingAmount <= 0) {
      // Goal already met
      setState(() {
        totalSavings = total;
        advisedMonthlyContribution = 0.0;
        suggestedDuration = 0;
      });
    } else {
      double requiredMonthlyContribution = remainingAmount / duration;
      // Suggesting a bank based on the calculated required monthly contribution
      String bank = '';
      if (requiredMonthlyContribution >= 50000) {
        bank = 'CRDB Bank';
      } else if (requiredMonthlyContribution >= 30000) {
        bank = 'NMB Bank';
      } else if (requiredMonthlyContribution >= 10000) {
        bank = 'Stanbic Bank';
      } else {
        bank = 'Exim Bank';
      }

      // Calculating savings for different durations
      double maxSavings = 0.0;
      int maxDuration = 0;
      for (int i = 1; i <= duration; i++) {
        double currentTotal = monthlyContribution * i;
        if (currentTotal > maxSavings) {
          maxSavings = currentTotal;
          maxDuration = i;
        }
      }

      setState(() {
        totalSavings = total;
        advisedMonthlyContribution = requiredMonthlyContribution;
        suggestedDuration = maxDuration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Savings Plan Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your savings plan',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Goal Amount',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: monthlyContributionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monthly Contribution',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration (in months)',
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.orange,
                  ),
                ),
                onPressed: calculateTotalSavings,
                child: Text('Calculate Total Savings'),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Savings:',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              totalSavings.toStringAsFixed(2),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            if (advisedMonthlyContribution > 0)
              Text(
                'To meet your goal amount, add $advisedMonthlyContribution per month.',
                style: TextStyle(fontSize: 18.0),
              ),
            if (suggestedDuration > 0)
              Text(
                'Suggested duration for maximum savings: $suggestedDuration months',
                style: TextStyle(fontSize: 18.0),
              ),
          ],
        ),
      ),
    );
  }
}
