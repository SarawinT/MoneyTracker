import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:moneytracker_app/models/category_list.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';
import 'package:moneytracker_app/widgets/categorized_chart.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/report_card.dart';
import '../appdata.dart';
import '../models/categorized_transaction_amount.dart';
import '../models/category.dart';
import '../models/dated_transaction_amount.dart';
import '../models/transaction.dart';
import '../services/firestore.dart';
import '../widgets/app_drawer.dart';
import '../widgets/date_chart.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isLoading = true;
  late String dateTimeText = "";
  late List<dynamic> datedTransactions = [];
  double sumIncome = 0;
  double sumExpense = 0;
  List<CategorizedTransactionAmount> cIncomeAmountChart = [];
  List<CategorizedTransactionAmount> cExpenseAmountChart = [];
  List<DatedTransactionAmount> dIncomeAmountChart = [];
  List<DatedTransactionAmount> dExpenseAmountChart = [];

  @override
  void initState() {
    dateTimeText = DateFormat("MMMM yyyy").format(AppData.startDate);
    initChartData();
    updateData();
    super.initState();
  }

  void initChartData() {
    cIncomeAmountChart = [];
    cExpenseAmountChart = [];
    dIncomeAmountChart = [];
    dExpenseAmountChart = [];
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
    isLoading = true;
    sumIncome = 0;
    sumExpense = 0;
    datedTransactions = await FireStore.getTransactionsFromDateRange(
        AppData.startDate, AppData.endDate);
    for (DatedTransaction datedTransaction in datedTransactions) {
      sumIncome += datedTransaction.getTotalIncome();
      sumExpense += datedTransaction.getTotalExpense();
      double sumIncomeDate = 0;
      double sumExpenseDate = 0;
      for (AppTransaction transaction in datedTransaction.transactions) {
        if (transaction.amount > 0) {
          sumIncomeDate += transaction.amount;
          int i = CategoryList.getIncomeIndex(transaction.category);
          cIncomeAmountChart[i].addAmount(transaction.amount);
        } else {
          sumExpenseDate += transaction.amount;
          int i = CategoryList.getExpenseIndex(transaction.category);
          cExpenseAmountChart[i].addAmount(transaction.amount);
        }
      }
      dIncomeAmountChart.add(DatedTransactionAmount(
          date: DateFormat("dd MMM")
              .format(DateTime.parse(datedTransaction.date)),
          amount: sumIncomeDate));
      dExpenseAmountChart.add(DatedTransactionAmount(
          date: DateFormat("dd MMM")
              .format(DateTime.parse(datedTransaction.date)),
          amount: sumExpenseDate));
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
    dIncomeAmountChart = List.from(dIncomeAmountChart.reversed);
    dExpenseAmountChart = List.from(dExpenseAmountChart.reversed);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(),
      ),
      drawer: const AppDrawer(
        pageIndex: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        AppData.startDate = Jiffy(AppData.startDate)
                            .subtract(months: 1)
                            .dateTime;
                        AppData.endDate = Jiffy(Jiffy(AppData.startDate)
                                .add(months: 1)
                                .dateTime)
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
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        AppData.startDate =
                            Jiffy(AppData.startDate).add(months: 1).dateTime;
                        AppData.endDate = Jiffy(Jiffy(AppData.startDate)
                                .add(months: 1)
                                .dateTime)
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
            isLoading
                ? Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 172,
                        ),
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Loading...",
                          style: GoogleFonts.kanit(
                              fontSize: 24,
                              color: const Color.fromARGB(255, 125, 125, 125)),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Report from ",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w600),
                            ),
                            Flexible(
                              child: Text(
                                "${DateFormat("dd MMM yyyy").format(AppData.startDate)} "
                                "- ${DateFormat("dd MMM yyyy").format(AppData.endDate)}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (datedTransactions.isEmpty)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(
                              height: 128,
                            ),
                            Icon(
                              Icons.collections_bookmark,
                              size: 128,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "No transaction from this month",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 24),
                            )
                          ],
                        ),
                      if (datedTransactions.isNotEmpty)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("NET INCOME"),
                                            (sumIncome + sumExpense) >= 0
                                                ? Text(
                                                    "${AppData.currency} ${AppData.moneyFormat.format(sumIncome + sumExpense)}",
                                                    style: const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.blue),
                                                  )
                                                : Text(
                                                    "${AppData.currency} ${AppData.moneyFormat.format(sumIncome + sumExpense)}",
                                                    style: const TextStyle(
                                                        fontSize: 36,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
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
                                    title: "INCOME",
                                    amount: sumIncome,
                                    onTap: () {
                                      if (cIncomeAmountChart.isEmpty) return;
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                128,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                128,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        splashRadius: 16,
                                                        icon: const Icon(
                                                            Icons.close))
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Center(
                                                      child: CategorizedChart(
                                                          dataSource:
                                                              cIncomeAmountChart,
                                                          title: "Income")),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                                  Expanded(
                                      child: ReportCard(
                                    isIncome: false,
                                    title: "EXPENSE",
                                    amount: sumExpense,
                                    onTap: () {
                                      if (cExpenseAmountChart.isEmpty) return;
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                128,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                128,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        splashRadius: 16,
                                                        icon: const Icon(
                                                            Icons.close))
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Center(
                                                      child: CategorizedChart(
                                                          dataSource:
                                                              cExpenseAmountChart,
                                                          title: "Expense")),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: DateChart(
                                    incomes: dIncomeAmountChart,
                                    expenses: dExpenseAmountChart,
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: CategorizedChart(
                                          dataSource: cIncomeAmountChart,
                                          title: "Income")),
                                  Expanded(
                                      child: CategorizedChart(
                                          dataSource: cExpenseAmountChart,
                                          title: "Expense"))
                                ],
                              ),
                            )
                          ],
                        )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
