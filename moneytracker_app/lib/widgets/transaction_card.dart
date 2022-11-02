import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/models/transaction.dart';
import 'package:moneytracker_app/pages/transaction_details.dart';

import '../pages/homepage.dart';

enum EditDeleteStatus {
  empty,
  deleteSuccess,
  deleteFail,
  editSuccess,
  editFail
}

class TransactionCard extends StatelessWidget {
  NumberFormat moneyFormat = NumberFormat.decimalPattern('en_us');
  final IconData icon;
  final Transaction transaction;
  final String username;

  TransactionCard(
      {Key? key,
      required this.icon,
      required this.transaction,
      required this.username})
      : super(key: key);

  int getID() {
    return transaction.id;
  }

  @override
  Widget build(BuildContext context) {
    HomepageState homepage = context.findAncestorStateOfType<HomepageState>()!;

    return InkWell(
        onTap: () async {
          var response = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionDetails(
                      transaction: transaction,
                      icon: icon,
                      username: username,
                    )),
          );

          if (response == EditDeleteStatus.empty) {
            return;
          }
          if (response == EditDeleteStatus.deleteSuccess) {
            homepage.updateData();
            homepage.showSnackBar('Transaction deleted');
            return;
          }

          if (response == null) {
            homepage.updateData();
            return;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(icon),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: GoogleFonts.kanit(fontSize: 18),
                  ),
                  Text(
                    transaction.note,
                    style: GoogleFonts.kanit(fontWeight: FontWeight.w300),
                  )
                ],
              )),
              Text(
                moneyFormat.format(transaction.amount),
                style: transaction.amount > 0
                    ? GoogleFonts.kanit(fontSize: 24, color: Colors.blue)
                    : GoogleFonts.kanit(fontSize: 24, color: Colors.red),
              )
            ],
          ),
        ));
  }
}
