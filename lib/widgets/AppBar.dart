// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:retirement_management_system/pages/login_page.dart';
import 'package:retirement_management_system/financial/reg2.dart';


class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
    iconTheme: IconThemeData(
    color: Colors.black, // Set the color of the menu icon to black
  ),
      title: Row(        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
      onTap: () { },
        child: Image.asset('assets/rms.png', height: 220,width: 100,
          ),
          ),
          const SizedBox(
            width: 4,
            height: 5
          ),
          // const Text('RETIREMENT MANAGEMENT SYSTEM'),
        ],
      ),
      centerTitle: true,
      titleSpacing: 20,
      toolbarHeight: 65,
      backgroundColor: Colors.orange,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed:() => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are you a customer or advisor?'),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.orange),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text('Customer',
                          style: TextStyle(color: Colors.orange,),),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(color: Colors.orange),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogiinPage()),
                            );
                          },
                          child: Text('Advisor',
                          style: TextStyle(color: Colors.orange,),),
                        ),
                      ],
                    );
                  },
                )
              },
              icon: const Icon(
                Icons.person_2_outlined,
                color: Colors.black,
                size: 40,
              )),
        )
      ],
    );
  }
}
