// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:retirement_management_system/financial/reg2.dart';
import 'package:retirement_management_system/pages/login_page.dart';

class MyUser extends StatelessWidget {
  const MyUser ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 350,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RETIREMENT MANAGEMENT SYSTEM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Your Tomorrow is Today',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
            SizedBox(height: 45,),
          Center( child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.orange),
                                  ),
                                  onPressed: () {
                                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Customer',
                                    ),
                                  ),
          ),
      ),
          SizedBox(height: 30,),
          Center( child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.orange),
                                  ),
                                  onPressed: () {
                                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogiinPage()),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      '   Advisor  ',
                                    ),
                                  ),
          ),
      ),
        ],
      ),
    );
  }
}









