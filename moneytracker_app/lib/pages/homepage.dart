import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:moneytracker_app/pages/create_transaction.dart';
import 'package:moneytracker_app/widgets/app_drawer.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/date_card.dart';
import 'package:moneytracker_app/widgets/transaction_card.dart';
import '../appdata.dart';
import '../models/category_list.dart';
import '../models/transaction.dart';
import '../services/api.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  TransactionListStatus listStatus = TransactionListStatus.loading;
  double balance = -1;
  late List<dynamic> datedTransactions = ["Loading..."];
  late String dateTimeText = "";

  Future updateData() async {
    datedTransactions = await API.getTransactionsFromDateRange(
        DateFormat("yyyy-MM-dd").format(AppData.startDate),
        DateFormat("yyyy-MM-dd").format(AppData.endDate));
    balance = await API.getBalance();
    setState(() {
      _setListStatus();
    });
    return;
  }

  void showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.kanit(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _setListStatus() {
    if (datedTransactions.isEmpty) {
      listStatus = TransactionListStatus.empty;
    } else if (datedTransactions[0] == "Loading...") {
      listStatus = TransactionListStatus.loading;
    } else if (datedTransactions[0] == null) {
      listStatus = TransactionListStatus.error;
    } else {
      listStatus = TransactionListStatus.normal;
    }
  }

  @override
  void initState() {
    dateTimeText = DateFormat("MMMM yyyy").format(AppData.startDate);
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomAppBarContent(
        balance: balance,
      )),
      drawer: const AppDrawer(
        pageIndex: 0,
      ),
      floatingActionButton: (listStatus == TransactionListStatus.normal ||
              listStatus == TransactionListStatus.empty)
          ? FloatingActionButton(
              onPressed: () async {
                var createResponse = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateTransaction()),
                );
                if (createResponse == null) {
                  return;
                }
                if (createResponse) {
                  updateData();
                  showSnackBar('Transaction created');
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: _buildPageBody(),
    );
  }

  Widget _buildPageBody() {
    switch (listStatus) {
      case TransactionListStatus.loading:
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Loading...",
                  style: GoogleFonts.kanit(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 125, 125, 125)),
                )
              ],
            ),
          );
        }
      case TransactionListStatus.error:
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 96,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Unexpected Error!",
                  style: GoogleFonts.kanit(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 125, 125, 125)),
                )
              ],
            ),
          );
        }
      default:
        {
          return Column(
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
                            dateTimeText = DateFormat("MMMM yyyy")
                                .format(AppData.startDate);
                          });
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
                            dateTimeText = DateFormat("MMMM yyyy")
                                .format(AppData.startDate);
                          });
                          updateData();
                        },
                        icon: const Icon(Icons.chevron_right),
                        splashRadius: 22),
                  ],
                ),
              ),
              if (listStatus == TransactionListStatus.normal)
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (BuildContext buildContext, int i) {
                        return Column(
                          children: [
                            DateCard(
                                date: datedTransactions[i].date,
                                sum: datedTransactions[i].sum),
                            for (int j = 0;
                                j < datedTransactions[i].transactions.length;
                                ++j)
                              TransactionCard(
                                icon: datedTransactions[i]
                                            .transactions[j]
                                            .amount >
                                        0
                                    ? CategoryList.getIconIncome(
                                        datedTransactions[i]
                                            .transactions[j]
                                            .category)
                                    : CategoryList.getIconExpense(
                                        datedTransactions[i]
                                            .transactions[j]
                                            .category),
                                transaction:
                                    datedTransactions[i].transactions[j],
                              ),
                            const SizedBox(
                              height: 4,
                            )
                          ],
                        );
                      },
                      itemCount: datedTransactions.length),
                ),
              if (listStatus == TransactionListStatus.empty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 196,
                      ),
                      const Icon(
                        Icons.add_box_outlined,
                        size: 96,
                        color: Color.fromARGB(255, 125, 125, 125),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "No Transaction",
                        style: GoogleFonts.kanit(
                            fontSize: 24,
                            color: const Color.fromARGB(255, 125, 125, 125)),
                      )
                    ],
                  ),
                ),
            ],
          );
        }
    }
  }
}
