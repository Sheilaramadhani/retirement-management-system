// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, unused_element, avoid_print, empty_statements

import 'package:flutter/material.dart';
// import 'package:retirement_management_system/data/service_rating.dart';
import 'package:retirement_management_system/widgets/AppBarUser.dart';
import 'package:retirement_management_system/pages/body.dart';
import 'package:retirement_management_system/widgets/MyDrawer.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBarUser(),
      ),
      body: MyBodyUser(),
       
        );
      }
  }
              
              // child: Icon(Icons.star),
            
          // : null,



