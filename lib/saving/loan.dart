// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// This feature streamlines loan tracking and management by enabling input of loan details, monitoring progress, calculating repayment schedules, and maintaining organization.
class Loan {
  String id;
  String description;
  double amount;
  bool isPaid;

  Loan({
    required this.id,
    required this.description,
    this.amount = 0.0,
    this.isPaid = false,
  });

  factory Loan.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Loan(
      id: data['id'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      isPaid: data['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'isPaid': isPaid,
    };
  }
}

class LoanManagementApp extends StatelessWidget {
  final CollectionReference loanCollection =
      FirebaseFirestore.instance.collection('loans');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Management App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Loan Management'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AddLoanForm(loanCollection: loanCollection),
            SizedBox(height: 16.0),
            Expanded(
              child: LoanList(loanCollection: loanCollection),
            ),
          ],
        ),
      ),
    );
  }
}

class AddLoanForm extends StatefulWidget {
  final CollectionReference loanCollection;

  AddLoanForm({required this.loanCollection});

  @override
  _AddLoanFormState createState() => _AddLoanFormState();
}

class _AddLoanFormState extends State<AddLoanForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void addLoan() async {
    if (_formKey.currentState!.validate()) {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      String description = _descriptionController.text.trim();
      double amount = double.parse(_amountController.text.trim());

      Loan newLoan = Loan(
        id: id,
        description: description,
        amount: amount,
      );

      await widget.loanCollection.doc(id).set(newLoan.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Invalid amount';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.orange,
                ),
              ),
              onPressed: addLoan,
              child: Text('Add Loan'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoanList extends StatelessWidget {
  final CollectionReference loanCollection;

  LoanList({required this.loanCollection});

  Future<void> toggleLoanPayment(String id, bool newValue) async {
    await loanCollection.doc(id).update({'isPaid': newValue});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: loanCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<Loan> loans = snapshot.data!.docs.map((doc) => Loan.fromFirestore(doc)).toList();

        if (loans.isEmpty) {
          return Center(
            child: Text(
              'You don\'t have any loans yet.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: loans.length,
          itemBuilder: (BuildContext context, int index) {
            Loan loan = loans[index];
            return ListTile(
              title: Text(loan.description),
              subtitle: Text('Amount: Tshs ${loan.amount.toStringAsFixed(2)}'),
              trailing: Checkbox(
                value: loan.isPaid,
                onChanged: (bool? value) {
                  toggleLoanPayment(loan.id, value ?? false);
                },
              ),
            );
          },
        );
      },
    );
  }
}
