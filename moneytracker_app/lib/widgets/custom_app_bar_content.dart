import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/pages/homepage.dart';
import 'package:moneytracker_app/widgets/info_dialog.dart';
import '../appdata.dart';
import '../services/firestore.dart';

class CustomAppBarContent extends StatelessWidget {
  late double? balance;
  final TextEditingController _amountController = TextEditingController();
  final String title;

  CustomAppBarContent({Key? key, this.balance, this.title = "Money Tracker"})
      : super(key: key);

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
            title,
            style: GoogleFonts.kanit(fontSize: 20),
          ),
        ),
        if (balance != null && balance != -1)
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

                              await FireStore.setBalance(balance!);

                              Navigator.pop(context);
                              homepage?.updateData();
                              homepage?.showSnackBar("Balance updated");

                              // if (response.statusCode == 200) {
                              //   Navigator.pop(context);
                              //   homepage?.updateData();
                              //   homepage?.showSnackBar("Balance updated");
                              // } else {
                              //   return;
                              // }
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
                  "${AppData.currency} ${AppData.moneyFormat.format(balance)}",
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
