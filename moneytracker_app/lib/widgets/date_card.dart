import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateCard extends Card {
  String date;

  DateCard({required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.lightGreen,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: Text(
                  date,
                  style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ),
    );
  }

}