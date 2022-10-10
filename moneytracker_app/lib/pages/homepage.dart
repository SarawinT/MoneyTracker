import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/models/category.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';
import 'package:moneytracker_app/pages/add_transaction.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/date_card.dart';
import 'package:moneytracker_app/widgets/transaction_card.dart';
import 'package:http/http.dart' as http;

import '../models/category_list.dart';
import '../models/transaction.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double balance = -1;
  late List<dynamic> datedTransactions = [];

  Future<List> getTransaction() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/transaction/MeisterAP"));
    var jsonData = jsonDecode(response.body);
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

  Future<double> getBalance() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/user/MeisterAP"));
    var jsonData = jsonDecode(response.body);
    return jsonData['Balance'];
  }

  void _getData() async {
    datedTransactions = await getTransaction();
    balance = await getBalance();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: CustomAppBarContent(balance: balance)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var createReponse = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTransaction()),
            );
            if (createReponse) {
              datedTransactions = await getTransaction();
              balance = await getBalance();
              setState(() {});
              for (var dt in datedTransactions) {
                dt.printCheck();
              }
            }
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
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
                        transaction: datedTransactions[i].transactions[j]),
                  const SizedBox(
                    height: 4,
                  )
                ],
              );
            },
            itemCount: datedTransactions.length));
  }
}
