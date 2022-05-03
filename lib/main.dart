import 'package:flutter/material.dart';
import 'package:food_inventory/UI/Login/login.dart';

import 'UI/LandingPage/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  LandingPage(),
    );
  }
}
