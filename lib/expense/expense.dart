// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Management',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);

    if (title.isNotEmpty && amount != null && amount > 0) {
      final now = DateTime.now();
      final month = DateFormat('MMMM yyyy').format(now);

      _firestore.collection('expenses').add({
        'title': title,
        'amount': amount,
        'date': now,
        'month': month,
      });

      _titleController.clear();
      _amountController.clear();
    }
  }

  void _removeExpense(String expenseId) {
    _firestore.collection('expenses').doc(expenseId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Expense Management'),
      ),
      body: Column(
        children: [
          ExpenseForm(
            titleController: _titleController,
            amountController: _amountController,
            addExpense: _addExpense,
          ),
          Expanded(
            child: ExpenseList(
              firestore: _firestore,
              removeExpense: _removeExpense,
            ),
          ),
          TotalExpense(firestore: _firestore),
          ElevatedButton(
            child: Text('View Weekly Report'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WeeklyExpensePage(firestore: _firestore),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExpenseForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final Function addExpense;

  ExpenseForm({
    required this.titleController,
    required this.amountController,
    required this.addExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount (Tshs)'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                child: Text('Add Expense'),
                onPressed: () => addExpense(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseList extends StatelessWidget {
  final FirebaseFirestore firestore;
  final Function removeExpense;

  ExpenseList({
    required this.firestore,
    required this.removeExpense,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('expenses').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final expenses = snapshot.data!.docs;

        if (expenses.isEmpty) {
          return Center(child: Text('No expenses added yet.'));
        }

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (BuildContext context, int index) {
            final expense = expenses[index];

            return ListTile(
              title: Text(expense['title']),
              subtitle: Text(
                'Amount: Tshs ${expense['amount'].toStringAsFixed(2)}',
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => removeExpense(expense.id),
              ),
            );
          },
        );
      },
    );
  }
}

class TotalExpense extends StatelessWidget {
  final FirebaseFirestore firestore;

  TotalExpense({
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('expenses').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final expenses = snapshot.data!.docs;
        final totalExpense = expenses.fold(0.0, (sum, doc) => sum + doc['amount']);

        return Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.centerRight,
          child: Text(
            'Total Expense: Tshs ${totalExpense.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class WeeklyExpensePage extends StatefulWidget {
  final FirebaseFirestore firestore;

  WeeklyExpensePage({
    required this.firestore,
  });

  @override
  _WeeklyExpensePageState createState() => _WeeklyExpensePageState();
}

class _WeeklyExpensePageState extends State<WeeklyExpensePage> {
  late List<ExpenseData> chartData;

  @override
  void initState() {
    super.initState();
    chartData = [];
    loadChartData();
  }

  void loadChartData() {
    final DateTime now = DateTime.now();
    final DateTime startDate = now.subtract(Duration(days: 6));
    final DateTime endDate = now.add(Duration(days: 1));

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDateStr = formatter.format(startDate);
    final String endDateStr = formatter.format(endDate);

    widget.firestore
        .collection('expenses')
        .where('date', isGreaterThanOrEqualTo: startDateStr, isLessThan: endDateStr)
        .get()
        .then((QuerySnapshot snapshot) {
      final data = snapshot.docs;
      final Map<String, double> expenseMap = {};

      for (var doc in data) {
        final expense = doc.data() as Map<String, dynamic>;
        final double amount = expense['amount'];
        final String date = formatter.format(expense['date'].toDate());

        if (expenseMap.containsKey(date)) {
          expenseMap[date] = expenseMap[date]! + amount;
        } else {
          expenseMap[date] = amount;
        }
      }

      final List<ExpenseData> chartDataList = [];

      for (var entry in expenseMap.entries) {
        final DateTime date = formatter.parse(entry.key);
        final double amount = entry.value;

        final ExpenseData expenseData = ExpenseData(date, amount);
        chartDataList.add(expenseData);
      }

      setState(() {
        chartData = chartDataList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Expense Report'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            'Weekly Expense Chart',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: charts.TimeSeriesChart(
                [
                  charts.Series<ExpenseData, DateTime>(
                    id: 'Expense',
                    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (ExpenseData data, _) => data.date,
                    measureFn: (ExpenseData data, _) => data.amount,
                    data: chartData,
                  ),
                ],
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseData {
  final DateTime date;
  final double amount;

  ExpenseData(this.date, this.amount);
}
