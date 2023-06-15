// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  late int rating;

  void rateService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate the Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please rate our service from 1 to 5 (1 - Poor, 5 - Excellent):'),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  rating = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (rating >= 1 && rating <= 5) {
                  print('Thank you for rating our service!'); // You can perform additional actions based on the rating here
                  Navigator.of(context).pop();
                } else {
                  print('Invalid rating. Please enter a number between 1 and 5.');
                }
              },
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
        title: Text('Rating Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Rate Service'),
          onPressed: () {
            rateService();
          },
        ),
      ),
    );
  }
}

