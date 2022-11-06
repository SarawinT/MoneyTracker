import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:moneytracker_app/models/category_list.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';
import 'package:moneytracker_app/widgets/categorized_chart.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/report_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../appdata.dart';
import '../models/categorized_transaction_amount.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../services/api.dart';
import '../widgets/app_drawer.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late String dateTimeText = "";
  late List<dynamic> datedTransactions = ["Loading..."];
  double sumIncome = 0;
  double sumExpense = 0;
  List<CategorizedTransactionAmount> cIncomeAmountChart = [];
  List<CategorizedTransactionAmount> cExpenseAmountChart = [];

  @override
  void initState() {
    AppData.startDate = DateTime.now();
    AppData.startDate = DateTime.parse(
        "${AppData.startDate.year}-${AppData.startDate.month}-01");
    dateTimeText = DateFormat("MMMM yyyy").format(AppData.startDate);
    AppData.endDate = Jiffy(Jiffy(AppData.startDate).add(months: 1).dateTime)
        .subtract(days: 1)
        .dateTime;
    initChartData();
    updateData();
    super.initState();
  }

  void initChartData() {
    cIncomeAmountChart = [];
    cExpenseAmountChart = [];
    for (Category category in CategoryList.incomes) {
      cIncomeAmountChart
          .add(CategorizedTransactionAmount(category: category.name));
    }
    for (Category category in CategoryList.expenses) {
      cExpenseAmountChart
          .add(CategorizedTransactionAmount(category: category.name));
    }
  }

  void updateData() async {
    sumIncome = 0;
    sumExpense = 0;
    datedTransactions = await API.getTransactionsFromDateRange(
        DateFormat("yyyy-MM-dd").format(AppData.startDate),
        DateFormat("yyyy-MM-dd").format(AppData.endDate));
    for (DatedTransaction datedTransaction in datedTransactions) {
      sumIncome += datedTransaction.getTotalIncome();
      sumExpense += datedTransaction.getTotalExpense();
      for (Transaction transaction in datedTransaction.transactions) {
        if (transaction.amount > 0) {
          int i = CategoryList.getIncomeIndex(transaction.category);
          cIncomeAmountChart[i].addAmount(transaction.amount);
        } else {
          int i = CategoryList.getExpenseIndex(transaction.category);
          cExpenseAmountChart[i].addAmount(transaction.amount);
        }
      }
    }
    List<CategorizedTransactionAmount> toRemove = [];
    for (CategorizedTransactionAmount c in cIncomeAmountChart) {
      if (c.amount == 0) {
        toRemove.add(c);
      }
    }
    for (CategorizedTransactionAmount t in toRemove) {
      cIncomeAmountChart.remove(t);
    }
    toRemove = [];
    for (CategorizedTransactionAmount c in cExpenseAmountChart) {
      if (c.amount == 0) {
        toRemove.add(c);
      }
    }
    for (CategorizedTransactionAmount t in toRemove) {
      cExpenseAmountChart.remove(t);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print("incomes");
        for (CategorizedTransactionAmount c in cIncomeAmountChart) {
          print("   $c");
        }
        print("expense");
        for (CategorizedTransactionAmount c in cExpenseAmountChart) {
          print("   $c");
        }
      }),
      drawer: const AppDrawer(
        pageIndex: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      AppData.startDate =
                          Jiffy(AppData.startDate).subtract(months: 1).dateTime;
                      AppData.endDate = Jiffy(
                              Jiffy(AppData.startDate).add(months: 1).dateTime)
                          .subtract(days: 1)
                          .dateTime;
                      setState(() {
                        dateTimeText =
                            DateFormat("MMMM yyyy").format(AppData.startDate);
                      });
                      initChartData();
                      updateData();
                    },
                    icon: const Icon(Icons.chevron_left),
                    splashRadius: 22),
                SizedBox(
                  width: 156,
                  child: Text(
                    dateTimeText,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF005E08)),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      AppData.startDate =
                          Jiffy(AppData.startDate).add(months: 1).dateTime;
                      AppData.endDate = Jiffy(
                              Jiffy(AppData.startDate).add(months: 1).dateTime)
                          .subtract(days: 1)
                          .dateTime;
                      setState(() {
                        dateTimeText =
                            DateFormat("MMMM yyyy").format(AppData.startDate);
                      });
                      initChartData();
                      updateData();
                    },
                    icon: const Icon(Icons.chevron_right),
                    splashRadius: 22),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Report from ",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${DateFormat("dd MMM yyyy").format(AppData.startDate)} "
                  "- ${DateFormat("dd MMM yyyy").format(AppData.endDate)}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: ReportCard(
                  isIncome: true,
                  amount: sumIncome,
                )),
                Expanded(
                    child: ReportCard(
                  isIncome: false,
                  amount: sumExpense,
                ))
              ],
            ),
          ),
          Row(
            children: [
              Expanded(child: CategorizedChart(dataSource: cIncomeAmountChart, title: "Income")),
              Expanded(child: CategorizedChart(dataSource: cExpenseAmountChart, title: "Expense"))
            ],
          )
        ],
      ),
    );
  }
}
