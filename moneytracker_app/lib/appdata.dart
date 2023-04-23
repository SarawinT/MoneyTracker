import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppData {
  static String userID = "";
  static String userDisplayName = "";
  static DateTime startDate = DateTime.now();
  static DateTime endDate = DateTime.now();
  static MaterialColor primaryColor = Colors.green;
  static MaterialColor secondaryColor = Colors.lightGreen;
  static NumberFormat moneyFormat = NumberFormat.decimalPattern('en_us');
  static String currency = "฿";

}