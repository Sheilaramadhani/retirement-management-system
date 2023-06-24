// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _progressAmountController = TextEditingController();

  late DateTime _completionTime = DateTime.now();
  late DateTime _deadline = DateTime.now();

  CollectionReference goalsCollection = FirebaseFirestore.instance.collection('goals');

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
                    decoration: InputDecoration(labelText: 'Target Amount'),
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
                    decoration: InputDecoration(labelText: 'Progress Amount'),
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
            StreamBuilder<QuerySnapshot>(
              stream: goalsCollection.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                List<GoalData> goals = snapshot.data!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  return GoalData(
                    data['goal'],
                    data['targetAmount'],
                    data['progressAmount'],
                    data['completionTime'].toDate(),
                    data['deadline'].toDate(),
                    reached: data['reached'],
                  );
                }).toList();

                if (goals.isEmpty) {
                  return Text('No goals found.');
                }

                return Column(
                  children: goals.map((goal) => _buildGoalCard(goal)).toList(),
                );
              },
            ),
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

  void _addGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final goal = _goalController.text;
    final targetAmount = double.parse(_targetAmountController.text);
    final progressAmount = double.parse(_progressAmountController.text);

    // Check if the goal already exists
    QuerySnapshot snapshot = await goalsCollection.where('goal', isEqualTo: goal).get();
    if (snapshot.size > 0) {
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

    goalsCollection.add({
      'goal': goal,
      'targetAmount': targetAmount,
      'progressAmount': progressAmount,
      'completionTime': _completionTime,
      'deadline': _deadline,
      'reached': false,
    });

    setState(() {
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
          content: StreamBuilder<QuerySnapshot>(
            stream: goalsCollection.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              List<GoalData> goals = snapshot.data!.docs.map((DocumentSnapshot doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return GoalData(
                  data['goal'],
                  data['targetAmount'],
                  data['progressAmount'],
                  data['completionTime'].toDate(),
                  data['deadline'].toDate(),
                  reached: data['reached'],
                );
              }).toList();

              if (goals.isEmpty) {
                return Text('No goals found.');
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: goals.map((goal) => _buildGoalCard(goal)).toList(),
                ),
              );
            },
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

  Widget _buildGoalCard(GoalData goal) {
    return Card(
      child: ListTile(
        title: Text(goal.goal),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Target Amount: \$${goal.targetAmount.toStringAsFixed(2)}'),
            Text('Progress Amount: \$${goal.progressAmount.toStringAsFixed(2)}'),
            Text('Completion Time: ${goal.completionTime.toString()}'),
            Text('Deadline: ${goal.deadline.toString()}'),
            Checkbox(
              value: goal.reached,
              onChanged: (newValue) async {
                await goalsCollection.doc(goal.goal).update({'reached': newValue});
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
}
