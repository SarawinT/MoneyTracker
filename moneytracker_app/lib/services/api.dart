import 'dart:convert';
import 'package:intl/intl.dart';
import '../appdata.dart';
import '../models/dated_transaction.dart';
import '../models/transaction.dart';
import 'package:http/http.dart' as http;
import '../widgets/transaction_card.dart';

class API {
  static String baseUrl = "127.0.0.1:8000";

  static Future<List> getTransactions() async {
    var response =
        await http.get(Uri.http(baseUrl, "/transaction/${AppData.username}"));
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

  static Future<List> getTransactionsFromDateRange(
      String from, String to) async {
    final queryParameters = {
      'from': from,
      'to': to,
    };
    var response = await http.get(Uri.http(baseUrl,
        "/transaction/${AppData.username}/date/", queryParameters));
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

  static Future<double> getBalance() async {
    var response =
        await http.get(Uri.http(baseUrl, "/user/${AppData.username}"));
    if (response.statusCode != 200) {
      return -1;
    }
    var jsonData = jsonDecode(response.body);
    return jsonData['Balance'];
  }

  static Future<EditDeleteStatus> editTransaction(
      {required int id,
      required bool isExpense,
      required String category,
      required double amount,
      required DateTime selectedDate,
      required String note}) async {
    double editAmount;
    if (isExpense) {
      editAmount = amount * -1;
    } else {
      editAmount = amount;
    }
    String date = DateFormat("yyyy-M-dd").format(selectedDate);

    String requestJson = jsonEncode(<String, dynamic>{
      'ID': id,
      'Category': category,
      'Amount': editAmount,
      'Date': date,
      'Note': note
    });

    var response = await http.put(
      Uri.parse('http://$baseUrl/transaction/${AppData.username}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestJson,
    );

    if (response.statusCode == 200) {
      return EditDeleteStatus.editSuccess;
    } else {
      return EditDeleteStatus.editFail;
    }
  }

  static Future<bool> createTransaction(
      {required bool isExpense,
      required double amount,
      required String category,
      required DateTime selectedDate,
      required String note}) async {
    double createAmount;
    if (isExpense) {
      createAmount = amount * -1;
    } else {
      createAmount = amount;
    }
    String date = DateFormat("yyyy-M-dd").format(selectedDate);

    String requestJson = jsonEncode(<String, dynamic>{
      'Category': category,
      'Amount': createAmount,
      'Date': date,
      'Note': note
    });

    var response = await http.post(
      Uri.parse('http://$baseUrl/transaction/${AppData.username}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestJson,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<EditDeleteStatus> deleteTransaction({required int id}) async {
    var response = await http.delete(
      Uri.parse('http://$baseUrl/transaction/${AppData.username}/$id'),
    );

    if (response.statusCode == 200) {
      return EditDeleteStatus.deleteSuccess;
    } else {
      return EditDeleteStatus.deleteFail;
    }
  }

  static Future<Transaction> getTransactionByID({required int id}) async {
    var response = await http
        .get(Uri.http(baseUrl, "/transaction/${AppData.username}/id/$id"));
    var jsonData = jsonDecode(response.body);
    return Transaction(
        id: id,
        category: jsonData['Category'],
        amount: jsonData['Amount'],
        date: jsonData['Date'],
        note: jsonData['Note'],
        username: AppData.username);
  }

  static Future<http.Response> updateUserBalance(
      {required double balance}) async {
    String requestJson = jsonEncode(<String, dynamic>{
      'Username': AppData.username,
      'Balance': balance,
    });

    var response = await http.put(
      Uri.parse('http://$baseUrl/user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestJson,
    );

    return response;
  }
}
