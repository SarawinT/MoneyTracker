import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/appdata.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';

import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

class FireStore {
  static Future createUser() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    final json = {
      'UserID': AppData.userID,
      'Balance': 0,
      'LatestTransactionID': 0
    };
    final userData = await getUserData();
    if (userData.docs.length == 0) {
      docUser.set(json);
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserData() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('UserID', isEqualTo: AppData.userID)
            .get();
    return querySnapshot;
  }

  static Future setTransactionID(int newID) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: AppData.userID)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final DocumentReference documentRef = snapshot.docs.first.reference;
      await documentRef.update({'LatestTransactionID': newID});
    } else {
      throw Exception('User not found');
    }
  }

  static Future setBalance(double newBalance) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: AppData.userID)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final DocumentReference documentRef = snapshot.docs.first.reference;
      await documentRef.update({'Balance': newBalance});
    } else {
      throw Exception('User not found');
    }
  }

  static Future<AppTransaction> getTransactionByID({required int id}) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('UserID', isEqualTo: AppData.userID)
        .where('ID', isEqualTo: id)
        .get();
    var t = snapshot.docs.first;
    return AppTransaction(
        id: t['ID'],
        category: t['Category'],
        amount: t['Amount'],
        date: DateFormat('yyyy-MM-dd').format(t['Date'].toDate()),
        note: t['Note'],
        username: t['UserID']);
  }

  static Future<List> getTransactionsFromDateRange(
      DateTime from, DateTime to) async {
    List<DatedTransaction> dtList = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('transactions')
            .where('UserID', isEqualTo: AppData.userID)
            .where('Date', isGreaterThanOrEqualTo: from)
            .where('Date', isLessThanOrEqualTo: to)
            .orderBy('Date', descending: true)
            .orderBy('ID', descending: true)
            .get();

    String cDate = "";
    for (dynamic t in querySnapshot.docs) {
      AppTransaction transaction = AppTransaction(
          id: t.data()['ID'],
          category: t.data()['Category'],
          amount: t.data()['Amount'],
          date: DateFormat('yyyy-MM-dd').format(t.data()['Date'].toDate()),
          note: t.data()['Note'],
          username: t.data()['UserID']);

      String tDate = DateFormat('yyyy-MM-dd').format(t.data()['Date'].toDate());
      if (tDate == cDate) {
        dtList.last.transactions.add(transaction);
      } else {
        cDate = tDate;
        List<AppTransaction> tList = [];
        DatedTransaction dt =
            DatedTransaction(date: cDate, transactions: tList);
        dtList.add(dt);
        dt.addTransaction(transaction);
      }
    }

    return dtList;
  }

  static Future<int> getLastTransactionID() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: AppData.userID)
        .get();
    int id = snapshot.docs.first['LatestTransactionID'];
    return id;
  }

  static Future<double> getBalance() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('UserID', isEqualTo: AppData.userID)
        .get();
    return snapshot.docs.first['Balance'];
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

    double balance = await getBalance();
    if (balance + createAmount < 0) return false;

    final docTransaction =
        FirebaseFirestore.instance.collection('transactions').doc();
    final id = await getLastTransactionID() + 1;
    final json = {
      'ID': id,
      'Category': category,
      'Amount': createAmount,
      'Date': selectedDate,
      'Note': note,
      'UserID': AppData.userID,
      'TimeStamp': DateTime.now()
    };

    docTransaction.set(json);
    setTransactionID(id);
    setBalance(balance + createAmount);

    return true;
  }

  static Future<EditDeleteStatus> deleteTransaction({required int id}) async {
    double balance = await getBalance();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('UserID', isEqualTo: AppData.userID)
          .where('ID', isEqualTo: id)
          .get();
      double deleteAmount = snapshot.docs.first['Amount'];

      snapshot.docs.forEach((doc) async {
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(doc.id)
            .delete();
      });
      setBalance(balance - deleteAmount);
    } catch (e) {
      print('Error deleting data: $e');
    }
    return EditDeleteStatus.deleteSuccess;
  }

  static Future<EditDeleteStatus> editTransaction(
      {required int id,
      required bool isExpense,
      required String category,
      required double amount,
      required DateTime selectedDate,
      required String note,
      required double oldAmount}) async {
    double editAmount;
    if (isExpense) {
      editAmount = amount * -1;
    } else {
      editAmount = amount;
    }

    double diff = (oldAmount - editAmount);
    double balance = await getBalance();
    if (balance - diff < 0) return EditDeleteStatus.editFail;

    var toUpdate = {
      'Category': category,
      'Amount': editAmount,
      'Date': selectedDate,
      'Note': note
    };

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('UserID', isEqualTo: AppData.userID)
        .where('ID', isEqualTo: id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final DocumentReference documentRef = snapshot.docs.first.reference;
      await documentRef.update(toUpdate);
      setBalance(balance - diff);
    } else {
      throw Exception('User not found');
    }
    return EditDeleteStatus.editSuccess;
  }
}
