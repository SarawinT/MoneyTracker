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

  double getTotalIncome() {
    double sum = 0;
    for (Transaction transaction in transactions) {
      if (transaction.amount > 0) {
        sum += transaction.amount;
      }
    }
    return sum;
  }

  double getTotalExpense() {
    double sum = 0;
    for (Transaction transaction in transactions) {
      if (transaction.amount < 0) {
        sum += transaction.amount;
      }
    }
    return sum;
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