import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/pages/homepage.dart';
import 'package:moneytracker_app/pages/loading_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String username = "";

  void _loadUsername() async {
    final String response =
        await rootBundle.loadString('assets/config/config.json');
    setState(() {
      username = jsonDecode(response)['Username'];
    });
  }

  @override
  void initState() {
    _loadUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Stack(
        children: [
          if (username.isNotEmpty)
            Homepage(
              username: username,
            ),
          if (username.isEmpty) const LoadingPage(),
        ],
      ),
    );
  }
}
