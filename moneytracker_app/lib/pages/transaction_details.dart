import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/models/transaction.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:http/http.dart' as http;

class TransactionDetails extends StatefulWidget {
  final Transaction transaction;
  final IconData icon;
  late String _formattedDate = "";
  TransactionDetails({Key? key, required this.transaction, required this.icon})
      : super(key: key) {
    DateTime dt = DateTime.parse(transaction.date);
    DateTime now = DateTime.now();

    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      _formattedDate = "Today";
    } else if (dt.day == now.day - 1 &&
        dt.month == now.month &&
        dt.year == now.year) {
      _formattedDate = "Yesterday";
    } else {
      _formattedDate = DateFormat("EEEE, dd/M/yyyy").format(dt);
    }
  }

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  Future<bool> deleteTransaction() async {
    var response = await http.delete(
      Uri.parse(
          'http://127.0.0.1:8000/transaction/MeisterAP/${widget.transaction.id}'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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
                  onPressed: () async {
                    bool success = false;
                    var response = await deleteTransaction().then((value) {
                      success = value;
                    });
                    if (success) {
                      Navigator.pop(context, success);
                      setState(() {});
                    } else {
                      print("not success");
                    }
                  },
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
                widget.icon,
                size: 48,
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.category,
                    style: GoogleFonts.kanit(fontSize: 24),
                  ),
                  widget.transaction.amount > 0
                      ? Text(
                          "฿ ${widget.transaction.amount}",
                          style: GoogleFonts.kanit(
                              fontSize: 20, color: Colors.blue),
                        )
                      : Text(
                          "- ฿ ${widget.transaction.amount * -1}",
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
          if (widget.transaction.note.isNotEmpty)
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
                  widget.transaction.note,
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
                widget._formattedDate,
                style: GoogleFonts.kanit(fontSize: 16),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
