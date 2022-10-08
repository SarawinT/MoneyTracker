import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBarContent extends StatelessWidget {
  final double balance;

  CustomAppBarContent({Key? key, required this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.wallet,
          size: 36,
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
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 4),
              child: Text(
                "฿ $balance",
                style: GoogleFonts.kanit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
      ],
    );
  }
}
