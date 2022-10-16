import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moneytracker_app/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'dated_transaction.dart';

class AppData extends ChangeNotifier {
  double balance = -1;
  List<dynamic> datedTransactions = ["Loading..."];

  void refreshTransaction() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/transaction/MeisterAP"));
    if (response.statusCode != 200) {
      datedTransactions = [null];
    }
    var jsonData = jsonDecode(response.body);
    if (jsonData == null) datedTransactions = [];
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
    datedTransactions = dt;
    notifyListeners();
  }

  void refreshBalance() async {
    var response =
        await http.get(Uri.http("127.0.0.1:8000", "/user/MeisterAP"));
    if (response.statusCode != 200) {
      balance = -1;
    }
    var jsonData = jsonDecode(response.body);
    balance = jsonData['Balance'];
    notifyListeners();
  }

  void updateData() async {
    refreshTransaction();
    refreshBalance();
    notifyListeners();
  }
}
