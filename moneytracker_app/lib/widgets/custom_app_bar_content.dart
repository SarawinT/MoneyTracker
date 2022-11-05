import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/pages/homepage.dart';
import 'package:moneytracker_app/widgets/info_dialog.dart';
import '../services/api.dart';

class CustomAppBarContent extends StatelessWidget {
  final NumberFormat moneyFormat = NumberFormat.decimalPattern('en_us');
  late double? balance;
  final TextEditingController _amountController = TextEditingController();

  CustomAppBarContent({Key? key, this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomepageState? homepage = context.findAncestorStateOfType<HomepageState>();

    return Row(
      children: [
        homepage == null
            ? const Icon(
                Icons.wallet,
                size: 36,
              )
            : InkWell(
                onTap: () {
                  homepage.updateData();
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const InfoDialog();
                    },
                  );
                },
                child: const Icon(
                  Icons.wallet,
                  size: 36,
                ),
              ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Text(
            "Money Tracker",
            style: GoogleFonts.kanit(fontSize: 24),
          ),
        ),
        if (balance != null)
          Card(
            child: InkWell(
              onTap: () {
                _amountController.text = "$balance";
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Enter new money"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              if (_amountController.text.isEmpty) return;
                              if (double.tryParse(_amountController.text) ==
                                  balance) {
                                Navigator.pop(context);
                                return;
                              }
                              balance =
                                  double.tryParse(_amountController.text)!;

                              var response = await API.updateUserBalance(
                                  balance: balance!);

                              if (response.statusCode == 200) {
                                Navigator.pop(context);
                                homepage?.updateData();
                                homepage?.showSnackBar("Balance updated");
                              } else {
                                return;
                              }
                            },
                            child: const Text("OK"))
                      ],
                      content: TextField(
                        style: GoogleFonts.kanit(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: GoogleFonts.kanit(
                              fontSize: 24, fontWeight: FontWeight.w500),
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
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 2, bottom: 2),
                child: Text(
                  "฿ ${moneyFormat.format(balance)}",
                  style: GoogleFonts.kanit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
