import 'transaction.dart';

class DatedTransaction {
  String date;
  List<Transaction> transactions;

  DatedTransaction({required this.date, required this.transactions});

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