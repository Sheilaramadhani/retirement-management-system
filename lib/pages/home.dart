// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_function_literals_in_foreach_calls, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:retirement_management_system/widgets/AppBar.dart';
import 'package:retirement_management_system/widgets/MyBody.dart';
import 'package:rate_my_app/rate_my_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late RateMyApp rateMyApp;
  @override
void initState() {
  super.initState();
  rateMyApp = RateMyApp(
    minDays: 0,
    minLaunches: 1,
    remindDays: 4,
    remindLaunches: 15,
  );
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await rateMyApp.init();
    rateMyApp.conditions.forEach((condition) {
      if (condition is DebuggableCondition) {
        print(condition.valuesAsString);
        // condition.reset();
      }
    });
    if (mounted && rateMyApp.shouldOpenDialog) {
      rateMyApp.showRateDialog(
        context,
        ignoreNativeDialog: Platform.isAndroid,
        onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        dialogStyle: DialogStyle(
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
          titleStyle: TextStyle(
            color: Colors.black, // Change to orange color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          messageStyle: TextStyle(
            color: Colors.orange, // Change to orange color
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      );
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: MyAppBar(),
      ),
      body: MyBody(),
    );
  }
}