class Transaction {
  int id;
  String category;
  double amount;
  String date;
  String note;
  String username;

  Transaction(
      {required this.id,
      required this.category,
      required this.amount,
      required this.date,
      required this.note,
      required this.username});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
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
