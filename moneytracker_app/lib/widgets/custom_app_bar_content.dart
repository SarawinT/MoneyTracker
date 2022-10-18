import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneytracker_app/pages/homepage.dart';

class CustomAppBarContent extends StatelessWidget {
  final double balance;
  NumberFormat moneyFormat = NumberFormat.decimalPattern('en_us');

  CustomAppBarContent({Key? key, required this.balance}) : super(key: key);

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
        if (balance != -1)
          Card(
            child: InkWell(
              onTap: () {},
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
