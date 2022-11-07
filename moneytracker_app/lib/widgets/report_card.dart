import 'package:flutter/material.dart';
import 'package:moneytracker_app/appdata.dart';

class ReportCard extends StatelessWidget {
  final double amount;
  final String title;
  Function? onTap;

  ReportCard({Key? key, required this.amount, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (onTap != null) onTap!();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              amount > 0
                  ? Text(
                      "฿ ${AppData.moneyFormat.format(amount)}",
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    )
                  : Text(
                      "฿ ${AppData.moneyFormat.format(amount)}",
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.red),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
