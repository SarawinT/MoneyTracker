import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
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
    AppData.startDate = DateTime.now();
    if (AppData.startDate.month < 10) {
      AppData.startDate = DateTime.parse(
          "${AppData.startDate.year}-0${AppData.startDate.month}-01");
    } else {
      AppData.startDate = DateTime.parse(
          "${AppData.startDate.year}-${AppData.startDate.month}-01");
    }
    AppData.endDate = Jiffy(Jiffy(AppData.startDate).add(months: 1).dateTime)
        .subtract(days: 1)
        .dateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Tracker',
      theme: ThemeData(
        primarySwatch: AppData.primaryColor,
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Stack(
        children: [
          if (!_loading) const Homepage(),
          if (_loading) const LoadingPage(),
        ],
      ),
    );
  }
}
