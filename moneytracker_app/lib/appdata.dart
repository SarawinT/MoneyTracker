import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppData {
  static String username = "";
  static DateTime startDate = DateTime.now();
  static DateTime endDate = DateTime.now();
  static MaterialColor primaryColor = Colors.green;
  static MaterialColor secondaryColor = Colors.lightGreen;
  static NumberFormat moneyFormat = NumberFormat.decimalPattern('en_us');

}