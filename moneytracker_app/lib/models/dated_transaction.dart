import 'transaction.dart';

class DatedTransaction {
  String date;
  double sum = 0;
  List<Transaction> transactions;

  DatedTransaction({required this.date, required this.transactions}) {
    for (Transaction t in transactions) {
      sum += t.amount;
    }
  }

  void printCheck() {
    print(date);
    for (Transaction t in transactions) {
      t.printCheck();
    }
  }

  void addTransaction(Transaction t) {
    transactions.add(t);
  }



}