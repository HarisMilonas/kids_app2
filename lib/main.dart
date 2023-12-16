import 'package:flutter/material.dart';
import 'package:kids_app/screens/home_page.dart';

import 'package:intl/intl.dart';

void main() {
  Intl.defaultLocale = "el";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 252, 23, 7)
          //  const Color.fromARGB(255, 234, 134, 168),
          ),
      home: const MyHomePage(),
    );
  }
}
