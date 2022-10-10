import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/widgets/category_card.dart';

import '../models/category.dart';
import '../models/category_list.dart';

class CategorySelector extends Dialog {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Select category',
            style: GoogleFonts.kanit(fontSize: 24),
          ),
          bottom: TabBar(
            labelStyle: GoogleFonts.kanit(),
            tabs: const [
              Tab(
                text: "Expense",
              ),
              Tab(text: "Income"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.55,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemBuilder: (BuildContext buildContext, int i) {
                    return CategoryCard(
                      icon: CategoryList.expenses[i].icon,
                      name: CategoryList.expenses[i].name,
                      isExpense: true,
                    );
                  },
                  itemCount: CategoryList.expenses.length,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.55,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemBuilder: (BuildContext buildContext, int i) {
                    return CategoryCard(
                      icon: CategoryList.incomes[i].icon,
                      name: CategoryList.incomes[i].name,
                      isExpense: false,
                    );
                  },
                  itemCount: CategoryList.incomes.length,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
