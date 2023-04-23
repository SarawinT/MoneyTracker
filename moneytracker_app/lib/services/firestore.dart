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
      'userID': AppData.username,
      'balance': 0,
      'LatestTransactionID': 0
    };
    final userData = await getUserData();
    if (userData.docs.length == 0) {
      docUser.set(json);
    } else {
      print(userData.docs[0].data());
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserData() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('userID', isEqualTo: AppData.username)
            .get();
    return querySnapshot;
  }

  static Future setUserTransactionID(int newID) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: AppData.username)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final DocumentReference documentRef = snapshot.docs.first.reference;
      await documentRef.update({'LatestTransactionID': newID});
    } else {
      throw Exception('User not found');
    }
  }

  static Future<double> getBalance() async {
    final userData = await getUserData();
    return userData.docs[0].data()['balance'];
  }

  static Future<List> getTransactionsFromDateRange(
      DateTime from, DateTime to) async {
    List<DatedTransaction> dtList = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('transactions')
            .where('UserID', isEqualTo: AppData.username)
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
        dt.transactions.add(transaction);
      }
    }

    return dtList;
  }

  static Future<int> getLastTransactionID() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userID', isEqualTo: AppData.username)
        .get();
    int id = snapshot.docs.first['LatestTransactionID'];
    return id;
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
    ;
    final docTransaction =
        FirebaseFirestore.instance.collection('transactions').doc();
    final id = await getLastTransactionID() + 1;
    final json = {
      'ID': id,
      'Category': category,
      'Amount': createAmount,
      'Date': selectedDate,
      'Note': note,
      'UserID': AppData.username,
      'TimeStamp': DateTime.now()
    };
    setUserTransactionID(id);
    docTransaction.set(json);

    return true;
  }

  static Future<EditDeleteStatus> deleteTransaction({required int id}) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('UserID', isEqualTo: AppData.username)
          .where('ID', isEqualTo: id)
          .get();
      snapshot.docs.forEach((doc) async {
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(doc.id)
            .delete();
      });
    } catch (e) {
      print('Error deleting data: $e');
    }
    return EditDeleteStatus.deleteSuccess;
  }
}
