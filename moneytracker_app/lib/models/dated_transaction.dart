import 'transaction.dart';

class DatedTransaction {
  String date;
  double sum = 0;
  List<AppTransaction> transactions;

  DatedTransaction({required this.date, required this.transactions}) {
    for (AppTransaction t in transactions) {
      sum += t.amount;
    }
  }

  void addTransaction(AppTransaction t) {
    transactions.add(t);
    sum += t.amount;
  }

  double getTotalIncome() {
    double sum = 0;
    for (AppTransaction transaction in transactions) {
      if (transaction.amount > 0) {
        sum += transaction.amount;
      }
    }
    return sum;
  }

  double getTotalIncomeByCategory(String category) {
    double sum = 0;
    for (AppTransaction transaction in transactions) {
      if (transaction.amount > 0 && transaction.category == category) {
        sum += transaction.amount;
      }
    }
    return sum;
  }

  double getTotalExpense() {
    double sum = 0;
    for (AppTransaction transaction in transactions) {
      if (transaction.amount < 0) {
        sum += transaction.amount;
      }
    }
    return sum;
  }

  void printCheck() {
    print(date);
    for (AppTransaction t in transactions) {
      t.printCheck();
    }
  }



}