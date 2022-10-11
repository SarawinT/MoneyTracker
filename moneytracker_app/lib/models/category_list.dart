import 'package:flutter/material.dart';
import 'package:moneytracker_app/models/category.dart';

class CategoryList {
  static List<Category> expenses = [
    Category(icon: Icons.fastfood, name: "Food & Beverage"),
    Category(icon: Icons.sports_esports, name: "Entertainment"),
    Category(icon: Icons.sports_tennis_outlined, name: "Health & Fitness"),
    Category(icon: Icons.school, name: "Education"),
    Category(icon: Icons.shopping_bag, name: "Shopping"),
    Category(icon: Icons.medical_services, name: "Medicine"),
    Category(icon: Icons.add_chart, name: "Fees & Charges"),
    Category(icon: Icons.family_restroom, name: "Gifts & Donations"),
    Category(icon: Icons.handshake, name: "Lending"),
    Category(icon: Icons.inventory, name: "Others"),
  ];

  static List<Category> incomes = [
    Category(icon: Icons.card_giftcard, name: "Gift"),
    Category(icon: Icons.work, name: "Salary"),
    Category(icon: Icons.currency_exchange, name: "Refund"),
    Category(icon: Icons.inventory, name: "Others"),
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

  static IconData getIconIncome(String category) {
    int index = -1;
    index = incomes.indexWhere((element) {
      return element.name == category;
    });
    if (index < 0) {
      return Icons.question_mark;
    }

    return incomes[index].icon;
  }
}
