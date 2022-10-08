import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/models/transaction.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';

class TransactionDetails extends StatelessWidget {
  Transaction transaction;
  IconData icon;
  late String formattedDate;
  TransactionDetails({Key? key, required this.transaction, required this.icon})
      : super(key: key) {
    DateTime dt = DateTime.parse(transaction.date);
    DateTime now = DateTime.now();

    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      formattedDate = "Today";
    } else if (dt.day == now.day - 1 &&
        dt.month == now.month &&
        dt.year == now.year) {
      formattedDate = "Yesterday";
    } else {
      formattedDate = DateFormat("EEEE, dd/M/yyyy").format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(balance: -1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Transaction details",
                  style: GoogleFonts.kanit(
                      fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  splashRadius: 18),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  splashRadius: 18)
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              Icon(
                icon,
                size: 48,
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: GoogleFonts.kanit(fontSize: 24),
                  ),
                  transaction.amount > 0
                      ? Text(
                          "฿ ${transaction.amount}",
                          style: GoogleFonts.kanit(
                              fontSize: 20, color: Colors.blue),
                        )
                      : Text(
                          "- ฿ ${transaction.amount * -1}",
                          style: GoogleFonts.kanit(
                              fontSize: 20, color: Colors.red),
                        )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (transaction.note.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.list,
                  size: 32,
                ),
                const SizedBox(
                  width: 24,
                ),
                Text(
                  transaction.note,
                  style: GoogleFonts.kanit(fontSize: 16),
                ),
              ],
            ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 32,
              ),
              const SizedBox(
                width: 24,
              ),
              Text(
                formattedDate,
                style: GoogleFonts.kanit(fontSize: 16),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
