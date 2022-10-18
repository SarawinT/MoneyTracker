import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateCard extends Card {
  NumberFormat moneyFormat = NumberFormat.decimalPattern('en_us');
  final String date;
  final double sum;

  DateCard({Key? key, required this.date, required this.sum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(date);
    String weekDay = DateFormat('EEEE').format(dateTime);
    String monthYear = DateFormat('MMMM yyyy').format(dateTime);

    return Card(
      color: Colors.lightGreen,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              "${dateTime.day}",
              style: GoogleFonts.kanit(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weekDay,
                  style: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  monthYear,
                  style: GoogleFonts.kanit(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                )
              ],
            )),
            Text(
              moneyFormat.format(sum),
              style: GoogleFonts.kanit(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
