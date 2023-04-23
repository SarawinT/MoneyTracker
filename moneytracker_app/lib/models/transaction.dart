class AppTransaction {
  int id;
  String category;
  double amount;
  String date;
  String note;
  String username;

  AppTransaction(
      {required this.id,
      required this.category,
      required this.amount,
      required this.date,
      required this.note,
      required this.username});

  factory AppTransaction.fromJson(Map<String, dynamic> json) {
    return AppTransaction(
        id: json['ID'],
        category: json['Category'],
        amount: json['Amount'],
        date: json['Date'],
        note: json['Note'],
        username: json['Username']);
  }

  void printCheck() {
    print(
        "  - ID: $id, Category: $category, Amount: $amount, Date: $date, Note: $note, Username: $username");
  }
}

enum TransactionListStatus { empty, error, loading, normal }
