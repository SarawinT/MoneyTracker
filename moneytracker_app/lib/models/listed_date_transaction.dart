import 'transaction.dart';

import 'dated_transaction.dart';

class ListedDateTransaction {
  List<DatedTransaction> list = [];

  ListedDateTransaction.fromTransactions(List<Transaction> transactions) {
    String cDate = "";
    for (int i = 0; i<transactions.length; ++i) {
      if (i == 0) {
        cDate = transactions[0].date;
        list.add(DatedTransaction(date: cDate, transactions: [transactions[0]]));
        continue;
      }
      if (transactions[i].date == cDate) {
        list[list.length-1].addTransaction(transactions[i]);
      } else {
        cDate = transactions[i].date;
        list.add(DatedTransaction(date: cDate, transactions: []));
        list[list.length-1].addTransaction(transactions[i]);

      }

    }
  }

  List<DatedTransaction> self() {
    return list;
  }

  int size() {
    return list.length;
  }

  void printList() {
    for (var dt in list) {
      dt.printCheck();
    }
  }

}
