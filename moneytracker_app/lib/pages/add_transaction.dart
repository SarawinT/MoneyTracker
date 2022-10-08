import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";

  @override
  void initState() {
    _formatDate();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _formatDate();
      });
    }
  }

  void _formatDate() {
    DateTime now = DateTime.now();
    if (selectedDate.day == now.day &&
        selectedDate.month == now.month &&
        selectedDate.year == now.year) {
      formattedDate = "Today";
    } else if (selectedDate.day == now.day - 1 &&
        selectedDate.month == now.month &&
        selectedDate.year == now.year) {
      formattedDate = "Yesterday";
    } else {
      formattedDate = DateFormat("EEEE, dd/M/yyyy").format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(balance: -1),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(_amountController.text);
          print(selectedDate);
          print(_noteController.text);
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add transaction",
              style:
                  GoogleFonts.kanit(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 32,
                ),
                const SizedBox(
                  width: 40,
                ),
                Flexible(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: GoogleFonts.kanit(fontSize: 16),
                          border: InputBorder.none,
                        ),
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}'))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 32,
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Colors.green),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 8),
                            child: Text(
                              formattedDate,
                              style: GoogleFonts.kanit(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Icon(
                  Icons.list,
                  size: 32,
                ),
                const SizedBox(
                  width: 40,
                ),
                Flexible(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.green),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter note',
                          hintStyle: GoogleFonts.kanit(fontSize: 16),
                          border: InputBorder.none,
                        ),
                        controller: _noteController,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
