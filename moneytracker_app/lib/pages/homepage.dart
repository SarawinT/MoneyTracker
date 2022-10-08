import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';
import 'package:moneytracker_app/models/listed_date_transaction.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/date_card.dart';
import 'package:moneytracker_app/widgets/transaction_card.dart';
import 'package:http/http.dart' as http;

import '../models/transaction.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String _username = "MeisterAP";
  double balance = -1;
  late List<DatedTransaction> dt = [];

  void getTransaction() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/transaction/MeisterAP"));
    var jsonData = jsonDecode(response.body);
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
  }

  void getBalance() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/user/MeisterAP"));
    var jsonData = jsonDecode(response.body);
    balance = jsonData['Balance'];
  }

  @override
  void initState() {
    getTransaction();
    getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getTransaction();
    return Scaffold(
        appBar: AppBar(
            title: CustomAppBarContent(balance: balance)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext buildContext, int i) {
              return Column(
                children: [
                  DateCard(date: dt[i].date, sum: dt[i].sum),
                  for (int j = 0; j < dt[i].transactions.length; ++j)
                    TransactionCard(
                        icon: Icon(Icons.fastfood),
                        transaction: dt[i].transactions[j]),
                  const SizedBox(
                    height: 4,
                  )
                ],
              );
            },
            itemCount: dt.length));
  }
}
