// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last, prefer_final_fields, avoid_unnecessary_containers, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retirement_management_system/common/theme_helper.dart';
import 'package:retirement_management_system/options/optionscreen.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _currentIncomeController = TextEditingController();
  String? _selectedRetirementGoal;

  List<String> retirementGoals = [
    'Travel and Explore',
    'Spend Time with Family',
    'Start a New Business',
    'Pursue Hobbies',
    'Volunteer and Give Back',
    'Relax and Enjoy Life',
  ];

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Prepare your Life Today"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: ThemeHelper().textInputDecoration(
                          "Age",
                          'Please enter your age',
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter your age";
                          } else {
                            int? age = int.tryParse(val);
                            if (age == null) {
                              return "Please enter a valid age";
                            } else if (age < 15 || age > 60) {
                              return "Please enter a valid age between 55 and 60";
                            } else {
                              return null;
                            }
                          }
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: TextFormField(
                        controller: _currentIncomeController,
                        decoration: ThemeHelper().textInputDecoration(
                          "Current Income",
                          "Enter your Current Income",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your current income";
                          } else {
                            int? income = int.tryParse(value);
                            if (income == null) {
                              return "Please enter a valid number";
                            } else if (income <= 0) {
                              return "Please enter a positive number";
                            } else {
                              return null;
                            }
                          }
                        },
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRetirementGoal,
                        items: retirementGoals.map((goal) {
                          return DropdownMenuItem<String>(
                            value: goal,
                            child: Text(goal),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRetirementGoal = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a retirement goal';
                          }
                          return null;
                        },
                        hint: Text('Select Retirement Goal'),
                      ),
                    ),
                    SizedBox(height: 100.0),
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final UserCredential userCredential =
                                await _auth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            await _firestore
                                .collection('users2')
                                .doc(userCredential.user!.uid)
                                .set({
                              'age': _ageController.text,
                              'currentincome': _currentIncomeController.text,
                              'retirementgoal': _selectedRetirementGoal,
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    InvestingOptionsScreen(
                                  age: int.parse(_ageController.text),
                                  income: int.parse(_currentIncomeController.text),
                                  goal: _selectedRetirementGoal!,
                                    ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Best Investment Options",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
