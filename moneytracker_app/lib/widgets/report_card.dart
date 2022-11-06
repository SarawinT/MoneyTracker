import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final double amount;
  final bool isIncome;

  ReportCard({Key? key, required this.isIncome, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isIncome ? const Text("TOTAL INCOME") : const Text("TOTAL EXPENSE"),
            isIncome
                ? Text(
                    "฿ $amount",
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  )
                : Text(
                    "฿ $amount",
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  )
          ],
        ),
      ),
    );
  }
}
