import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/appdata.dart';
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
  bool _loading = true;

  void _loadUsername() async {
    final String response =
        await rootBundle.loadString('assets/config/config.json');

    setState(() {});

    AppData.username = jsonDecode(response)['Username'];
    // username = jsonDecode(response)['Username'];

    if (AppData.username.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 1800));
      setState(() {
        _loading = false;
      });
    }
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
          if (!_loading) const Homepage(),
          if (_loading) LoadingPage(),
        ],
      ),
    );
  }
}
