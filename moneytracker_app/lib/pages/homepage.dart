import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';
import 'package:moneytracker_app/models/listed_date_transaction.dart';
import 'package:moneytracker_app/widgets/date_card.dart';
import 'package:moneytracker_app/widgets/transaction_card.dart';
import 'package:http/http.dart' as http;

import '../models/transaction.dart';

List<Transaction> transactionList = [];

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
      Transaction transaction = Transaction(
          id: t['ID'],
          category: t['Category'],
          amount: t['Amount'],
          date: t['Date'],
          note: t['Note'],
          username: t['Username']);
      transactionList.add(transaction);
    }
    dt = ListedDateTransaction.fromTransactions(transactionList).self();
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
            title: Row(
          children: [
            const Icon(
              Icons.wallet,
              size: 36,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                "Money Tracker",
                style: GoogleFonts.kanit(fontSize: 24),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 4),
                child: Text(
                  "฿ $balance",
                  style: GoogleFonts.kanit(
                      fontSize: 24, fontWeight: FontWeight.bold, ),
                ),
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemBuilder: (BuildContext buildContext, int i) {
              return Column(
                children: [
                  DateCard(date: dt[i].date),
                  for (int j = 0; j < dt[i].transactions.length; ++j)
                    TransactionCard(
                        icon: Icon(Icons.fastfood),
                        transaction: dt[i].transactions[j])
                ],
              );
            },
            itemCount: dt.length));
  }
}
