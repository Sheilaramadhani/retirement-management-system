// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class InvestmentOption {
  final String name;
  final String description;

  InvestmentOption({required this.name, required this.description});
}

class InvestingOptionsScreen extends StatelessWidget {
  final List<InvestmentOption> investmentOptions = [
    InvestmentOption(
      name: 'Stocks',
      description: 'Invest in the Tanzanian stock market.',
    ),
    InvestmentOption(
      name: 'Government Securities',
      description: 'Invest in treasury bills and bonds issued by the Tanzanian government.',
    ),
    InvestmentOption(
      name: 'Real Estate',
      description: 'Invest in residential or commercial properties in Tanzania.',
    ),
    InvestmentOption(
      name: 'Agriculture',
      description: 'Invest in agricultural ventures and agribusiness in Tanzania.',
    ),
    InvestmentOption(
      name: 'Small and Medium Enterprises (SMEs)',
      description: 'Invest in small and medium-sized enterprises in Tanzania.',
    ),
    InvestmentOption(
      name: 'Mutual Funds',
      description: 'Invest in mutual funds that diversify investments across various assets.',
    ),
    InvestmentOption(
      name: 'Infrastructure Projects',
      description: 'Invest in infrastructure development projects in Tanzania.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Options in Tanzania'),
      ),
      body: ListView.builder(
        itemCount: investmentOptions.length,
        itemBuilder: (context, index) {
          final option = investmentOptions[index];
          return ListTile(
            title: Text(option.name),
            subtitle: Text(option.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvestmentOptionDetailsScreen(option: option),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InvestmentOptionDetailsScreen extends StatelessWidget {
  final InvestmentOption option;

  const InvestmentOptionDetailsScreen({required this.option});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(option.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(option.description),
      ),
    );
  }
}
