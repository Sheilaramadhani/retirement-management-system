// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalData {
  final String goal;
  final double targetAmount;
  final double progressAmount;
  final DateTime completionTime;
  final DateTime deadline;
  bool reached; // Added boolean field to track if the goal has been reached

  GoalData(this.goal, this.targetAmount, this.progressAmount, this.completionTime, this.deadline, {this.reached = false});
}

class GoalTrackerScreen extends StatefulWidget {
  @override
  _GoalTrackerScreenState createState() => _GoalTrackerScreenState();
}

class _GoalTrackerScreenState extends State<GoalTrackerScreen> {
  final List<GoalData> goals = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _progressAmountController = TextEditingController();
  late DateTime _completionTime = DateTime.now();
  late DateTime _deadline = DateTime.now();

  void _addGoal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final goal = _goalController.text;
    final targetAmount = double.parse(_targetAmountController.text);
    final progressAmount = double.parse(_progressAmountController.text);

    // Check if the goal already exists
    if (goals.any((existingGoal) => existingGoal.goal == goal)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Goal Already Exists'),
            content: Text('The goal "$goal" is already available.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      goals.add(GoalData(goal, targetAmount, progressAmount, _completionTime, _deadline));
      _goalController.clear();
      _targetAmountController.clear();
      _progressAmountController.clear();
      _completionTime = DateTime.now();
      _deadline = DateTime.now();
    });
  }

  void _viewGoals() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Goals'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: goals.map((goal) => _buildGoalCard(goal)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Goal Tracker'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _goalController,
                    decoration: InputDecoration(labelText: 'Goal'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a goal.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _targetAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Target Amount (Tshs)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a target amount.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid target amount.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _progressAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Progress Amount (Tshs)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a progress amount.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid progress amount.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Text('Completion Time: ${_completionTime.toString()}'),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: () async {
                      final selectedTime = await showDatePicker(
                        context: context,
                        initialDate: _completionTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _completionTime = selectedTime;
                        });
                      }
                    },
                    child: Text('Select Completion Time'),
                  ),
                  SizedBox(height: 16),
                  Text('Deadline: ${_deadline.toString()}'),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: () async {
                      final selectedTime = await showDatePicker(
                        context: context,
                        initialDate: _deadline,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _deadline = selectedTime;
                        });
                      }
                    },
                    child: Text('Select Deadline'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    onPressed: _addGoal,
                    child: Text('Add Goal'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Goals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            if (goals.isNotEmpty)
              Column(
                children: goals.map((goal) => _buildGoalCard(goal)).toList(),
              ),
            SizedBox(height: 10),
            if (goals.isNotEmpty) _buildGoalChart(),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: _viewGoals,
              child: Text('View Goals'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(GoalData goal) {
    return Card(
      child: ListTile(
        title: Text(goal.goal),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Target Amount: Tshs ${goal.targetAmount.toStringAsFixed(2)}'),
            Text('Progress Amount: Tshs ${goal.progressAmount.toStringAsFixed(2)}'),
            Text('Completion Time: ${goal.completionTime.toString()}'),
            Text('Deadline: ${goal.deadline.toString()}'),
            Checkbox(
              value: goal.reached,
              onChanged: (newValue) {
                setState(() {
                  goal.reached = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalChart() {
    List<ChartData> chartData = goals.map((goal) {
      return ChartData(goal.goal, goal.progressAmount);
    }).toList();

    return Container(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.goal,
            yValueMapper: (ChartData data, _) => data.progressAmount,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String goal;
  final double progressAmount;

  ChartData(this.goal, this.progressAmount);
}
