import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/models/transaction.dart';
import 'package:moneytracker_app/pages/transaction_datails.dart';

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
    return InkWell(
        onTap: () async {
          var data = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionDetails(
                      transaction: transaction,
                      icon: icon,
                    )),
          );
          print(data);
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
                      style:
                          GoogleFonts.kanit(fontSize: 24, color: Colors.red),
                    )
            ],
          ),
        ));
  }
}
