import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final IconData icon;
  final Transaction transaction;


  const TransactionCard(
      {Key? key, required this.icon, required this.transaction})
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
              transaction.amount > 0
                  ? Text(
                      "${transaction.amount}",
                      style:
                          GoogleFonts.kanit(fontSize: 24, color: Colors.blue),
                    )
                  : Text(
                      "${transaction.amount}",
                      style: GoogleFonts.kanit(fontSize: 24, color: Colors.red),
                    )
            ],
          ),
        ));
  }
}
