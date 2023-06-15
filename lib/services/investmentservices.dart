// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:retirement_management_system/data/models.dart';
import 'package:retirement_management_system/services/investment_service.dart';

class InvestmentMonitoringScreen extends StatefulWidget {
  const InvestmentMonitoringScreen({Key? key}) : super(key: key);

  @override
  _InvestmentMonitoringScreenState createState() =>
      _InvestmentMonitoringScreenState();
}

class _InvestmentMonitoringScreenState
    extends State<InvestmentMonitoringScreen> {
  late List<Investment> _investments;
  late List<Account> _accounts;
  late List<charts.Series<Account, String>> _accountSeries;

  @override
  void initState() {
    super.initState();
    _loadInvestments();
    _loadAccounts();
    _buildAccountSeries();
  }

  void _loadInvestments() async {
    final investments = await InvestmentService.getInvestments();
    setState(() {
      _investments = investments;
    });
  }

  void _loadAccounts() async {
    final accounts = await InvestmentService.getAccounts();
    setState(() {
      _accounts = accounts;
    });
  }

  void _buildAccountSeries() {
    _accountSeries = [
      charts.Series<Account, String>(
        id: 'Accounts',
        domainFn: (account, _) => account.type,
        measureFn: (account, _) => account.balance,
        data: _accounts,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Monitoring'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Total Investments: \$${_investments.fold<double>(0, (sum, inv) => sum + inv.value).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Text(
              'Total Accounts: ${_accounts.length}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: charts.BarChart(
                _accountSeries,
                animate: true,
                vertical: false,
                barRendererDecorator: charts.BarLabelDecorator<String>(),
                domainAxis: const charts.OrdinalAxisSpec(
                  renderSpec: charts.NoneRenderSpec(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
