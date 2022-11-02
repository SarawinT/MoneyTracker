import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';
import 'package:moneytracker_app/pages/create_transaction.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/date_card.dart';
import 'package:moneytracker_app/widgets/transaction_card.dart';
import 'package:http/http.dart' as http;

import '../models/category_list.dart';
import '../models/transaction.dart';

class Homepage extends StatefulWidget {
  String username;
  Homepage({Key? key, required this.username}) : super(key: key);

  @override
  State<Homepage> createState() => HomepageState(username: username);
}

class HomepageState extends State<Homepage> {
  TransactionListStatus listStatus = TransactionListStatus.loading;
  final String username;
  double balance = -1;
  late List<dynamic> datedTransactions = ["Loading..."];
  HomepageState({required this.username});

  Future<List> _getTransaction() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/transaction/$username"));
    if (response.statusCode != 200) {
      return [null];
    }
    var jsonData = jsonDecode(response.body);
    if (jsonData == null) return [];
    List<DatedTransaction> dt = [];
    for (dynamic t in jsonData) {
      List<Transaction> tList = [];
      for (dynamic u in t['Transactions']) {
        tList.add(Transaction(
            id: u['ID'],
            category: u['Category'],
            amount: u['Amount'],
            date: u['Date'],
            note: u['Note'],
            username: u['Username']));
      }
      dt.add(DatedTransaction(date: t['Date'], transactions: tList));
    }

    return dt;
  }

  Future<double> _getBalance() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/user/$username"));
    if (response.statusCode != 200) {
      return -1;
    }
    var jsonData = jsonDecode(response.body);
    return jsonData['Balance'];
  }

  Future updateData() async {
    datedTransactions = await _getTransaction();
    balance = await _getBalance();
    setState(() {});
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
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    Widget pageBody;
    _setListStatus();

    switch (listStatus) {
      case TransactionListStatus.empty:
        {
          pageBody = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_box_outlined,
                  size: 96,
                  color: Color.fromARGB(255, 125, 125, 125),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "No transactions",
                  style: GoogleFonts.kanit(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 125, 125, 125)),
                )
              ],
            ),
          );
        }
        setState(() {});
        break;
      case TransactionListStatus.loading:
        {
          pageBody = Center(
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
        setState(() {});
        break;
      case TransactionListStatus.error:
        {
          pageBody = Center(
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
        setState(() {});
        break;
      default:
        {
          pageBody = ListView.builder(
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
                        icon: datedTransactions[i].transactions[j].amount > 0
                            ? CategoryList.getIconIncome(
                                datedTransactions[i].transactions[j].category)
                            : CategoryList.getIconExpense(
                                datedTransactions[i].transactions[j].category),
                        transaction: datedTransactions[i].transactions[j],
                        username: widget.username,
                      ),
                    const SizedBox(
                      height: 4,
                    )
                  ],
                );
              },
              itemCount: datedTransactions.length);
        }
        setState(() {});
        break;
    }

    return Scaffold(
      appBar: AppBar(
          title: CustomAppBarContent(
        balance: balance,
        username: widget.username,
      )),
      floatingActionButton: (listStatus == TransactionListStatus.normal)
          ? FloatingActionButton(
              onPressed: () async {
                var createResponse = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateTransaction(
                            username: widget.username,
                          )),
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
      body: pageBody,
    );
  }
}
