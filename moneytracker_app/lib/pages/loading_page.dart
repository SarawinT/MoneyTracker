import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Colors.green,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.wallet,
            color: Colors.white,
            size: 96,
          ),
          Text(
            "Money Tracker",
            style: GoogleFonts.kanit(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 36),
          ),
          const SizedBox(
            height: 48,
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ]),
      ),
    );
  }
}
