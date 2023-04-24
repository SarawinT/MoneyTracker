import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/models/category_list.dart';
import 'package:moneytracker_app/widgets/category_selector.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/transaction_card.dart';
import '../appdata.dart';
import '../models/transaction.dart';
import '../services/api.dart';
import '../services/firestore.dart';

class EditTransaction extends StatefulWidget {
  final AppTransaction transaction;
  EditTransaction({Key? key, required this.transaction}) : super(key: key);

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _formattedDate = "";
  String _selectedCategory = "Select category";
  bool _isExpense = true;
  IconData _icon = Icons.question_mark;

  String _feedback = "";

  @override
  void initState() {
    if (widget.transaction.amount > 0) _isExpense = false;
    _amountController.text = widget.transaction.amount > 0
        ? widget.transaction.amount.toString()
        : (widget.transaction.amount * -1).toString();
    _noteController.text = widget.transaction.note;
    _selectedDate = DateTime.parse(widget.transaction.date);
    _selectedCategory = widget.transaction.category;
    _icon = widget.transaction.amount > 0
        ? CategoryList.getIconIncome(widget.transaction.category)
        : CategoryList.getIconExpense(widget.transaction.category);

    _formatDate();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _formatDate();
      });
    }
  }

  void _formatDate() {
    DateTime now = DateTime.now();
    if (_selectedDate.day == now.day &&
        _selectedDate.month == now.month &&
        _selectedDate.year == now.year) {
      _formattedDate = "Today";
    } else if (_selectedDate.day == now.day - 1 &&
        _selectedDate.month == now.month &&
        _selectedDate.year == now.year) {
      _formattedDate = "Yesterday";
    } else {
      _formattedDate = DateFormat("EEEE, dd/M/yyyy").format(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool inputCheck = false;
          setState(() {
            if (_selectedCategory == "Select category") {
              _feedback = "Please select category";
            } else if (_amountController.text.isEmpty) {
              _feedback = "Please enter amount";
            } else {
              _feedback = "";
              inputCheck = true;
            }
          });
          if (inputCheck) {
            EditDeleteStatus status = EditDeleteStatus.editSuccess;
            status = await FireStore.editTransaction(
                id: widget.transaction.id,
                isExpense: _isExpense,
                amount: double.parse(_amountController.text),
                category: _selectedCategory,
                selectedDate: _selectedDate,
                note: _noteController.text,
                oldAmount: widget.transaction.amount);
            if (status == EditDeleteStatus.editSuccess) {
              Navigator.pop(context, status);
            } else {
              setState(() {
                _feedback = "Not enough money";
              });
            }
          }
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit transaction",
                  style:
                      GoogleFonts.kanit(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                const Divider(),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Icon(
                      _icon,
                      size: 32,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          var cData = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CategorySelector();
                              });
                          if (cData == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = cData.name;
                            _isExpense = cData.isExpense;
                            _icon = cData.icon;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.0, color: AppData.primaryColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 8),
                                child: _selectedCategory == "Select category"
                                    ? Text(
                                        _selectedCategory,
                                        style: GoogleFonts.kanit(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 125, 125, 125)),
                                      )
                                    : Text(
                                        _selectedCategory,
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
                  height: 24,
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
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(width: 2.0, color: AppData.primaryColor),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: TextField(
                            style: GoogleFonts.kanit(fontSize: 16),
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
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.0, color: AppData.primaryColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16, bottom: 8),
                                child: Text(
                                  _formattedDate,
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
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(width: 2.0, color: AppData.primaryColor),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: TextField(
                            style: GoogleFonts.kanit(fontSize: 16),
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
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Text(
                    _feedback,
                    style: GoogleFonts.kanit(color: Colors.red, fontSize: 18),
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
