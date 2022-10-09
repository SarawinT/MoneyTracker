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

class CategoryList {
  static List<Category> expenses = [
    Category(icon: Icons.fastfood, name: "Food & Beverage"),
    Category(icon: Icons.sports_esports, name: "Entertainment"),
    Category(icon: Icons.sports_tennis_outlined, name: "Health & Fitness"),
    Category(icon: Icons.school, name: "Education"),
    Category(icon: Icons.add_chart, name: "Fees & Charges"),
    Category(icon: Icons.family_restroom, name: "Gifts & Donations"),
    Category(icon: Icons.handshake, name: "Lending"),
  ];

  static List<Category> incomes = [
    Category(icon: Icons.card_giftcard, name: "Gift"),
  ];

  static IconData getIconExpense(String category) {
    int index = -1;
    index = expenses.indexWhere((element) {
      return element.name == category;
    });
    if (index < 0) {
      return Icons.question_mark;
    }

    return expenses[index].icon;

  }
}
