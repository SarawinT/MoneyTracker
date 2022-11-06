class CategorizedTransactionAmount {
  final String category;
  double amount = 0;

  CategorizedTransactionAmount({required this.category});

  @override
  String toString() {
    return "$category : $amount";
  }

  void addAmount(double a) {
    amount += a;
  }

  bool isZero() {
    if (amount == 0) {
      return true;
    }
    return false;
  }

}