import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/models/transaction.dart';
import 'package:moneytracker_app/pages/edit_transaction.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/transaction_card.dart';
import '../appdata.dart';
import '../services/api.dart';

class TransactionDetails extends StatefulWidget {
  final Transaction transaction;
  final IconData icon;
  String _formattedDate = "";
  TransactionDetails({
    Key? key,
    required this.transaction,
    required this.icon,
  }) : super(key: key) {
    _formatDate();
  }

  void _formatDate() {
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
  final NumberFormat moneyFormat = NumberFormat.decimalPattern('en_us');

  void _updateTransaction() async {
    Transaction toUpdate =
        await API.getTransactionByID(id: widget.transaction.id);
    widget.transaction.category = toUpdate.category;
    widget.transaction.amount = toUpdate.amount;
    widget.transaction.date = toUpdate.date;
    widget.transaction.note = toUpdate.note;
    widget._formatDate();

    setState(() {});
  }

  void showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.kanit(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
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
                  onPressed: () async {
                    var editResponse = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTransaction(
                                transaction: widget.transaction,
                              )),
                    );

                    if (editResponse == EditDeleteStatus.editSuccess) {
                      _updateTransaction();
                      showSnackBar('Transaction edited');
                    }
                  },
                  icon: const Icon(Icons.edit),
                  splashRadius: 18),
              IconButton(
                  onPressed: () async {
                    var statusD = await showDialog(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return AlertDialog(
                            title: Text(
                              "Delete Confirmation",
                              style: GoogleFonts.kanit(
                                  fontWeight: FontWeight.w500),
                            ),
                            content: Text(
                              "Delete this transaction?",
                              style: GoogleFonts.kanit(),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context, EditDeleteStatus.empty);
                                  },
                                  child:
                                      Text("No", style: GoogleFonts.kanit())),
                              TextButton(
                                  onPressed: () async {
                                    Object status = EditDeleteStatus.empty;
                                    status = await API.deleteTransaction(
                                        id: widget.transaction.id);
                                    if (status ==
                                        EditDeleteStatus.deleteSuccess) {
                                      Navigator.pop(context,
                                          EditDeleteStatus.deleteSuccess);
                                    }
                                  },
                                  child:
                                      Text("Yes", style: GoogleFonts.kanit()))
                            ],
                          );
                        });
                    if (statusD == EditDeleteStatus.deleteSuccess) {
                      Navigator.pop(context, statusD);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              Icon(
                widget.icon,
                size: 52,
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
                          "${AppData.currency} ${moneyFormat.format(widget.transaction.amount)}",
                          style: GoogleFonts.kanit(
                              fontSize: 20, color: Colors.blue),
                        )
                      : Text(
                          "- ${AppData.currency} ${moneyFormat.format(widget.transaction.amount * -1)}",
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
          ),
          const SizedBox(
            height: 16,
          ),
          if (widget.transaction.note.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.list,
                  size: 32,
                ),
                const SizedBox(
                  width: 24,
                ),
                Flexible(
                  child: Text(
                    widget.transaction.note,
                    style: GoogleFonts.kanit(fontSize: 16),
                    softWrap: true,
                  ),
                ),
              ],
            ),
        ]),
      ),
    );
  }
}
