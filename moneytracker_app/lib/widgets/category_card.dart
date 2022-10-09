import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  IconData icon;
  String name;
  bool isExpense;

  CategoryCard(
      {Key? key,
      required this.icon,
      required this.name,
      required this.isExpense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, CategoryData(name: name, isExpense: isExpense, icon: icon));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Text(
              name,
              style: GoogleFonts.kanit(fontSize: 16),
            ))
          ],
        ),
      ),
    );
  }
}
