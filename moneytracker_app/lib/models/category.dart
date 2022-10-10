import 'package:flutter/material.dart';

class Category {
  IconData icon;
  String name;

  Category({required this.icon, required this.name});
}

class CategoryData {
  String name;
  bool isExpense;
  IconData icon;

  CategoryData(
      {required this.name, required this.isExpense, required this.icon});
}

