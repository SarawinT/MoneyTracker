import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/categorized_transaction_amount.dart';

class CategorizedChart extends StatelessWidget {
  final List<CategorizedTransactionAmount> dataSource;
  final String title;
  const CategorizedChart({Key? key, required this.dataSource, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(

        title: ChartTitle(
            text: title, textStyle: GoogleFonts.kanit()),
        legend: Legend(isVisible: true,textStyle: GoogleFonts.kanit()),
        series: <CircularSeries>[
          DoughnutSeries<CategorizedTransactionAmount, String>(
              dataSource: dataSource,
              xValueMapper: (CategorizedTransactionAmount data, _) =>
              data.category,
              yValueMapper: (CategorizedTransactionAmount data, _) =>
              data.amount,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true, textStyle: GoogleFonts.kanit()))
        ]);
  }
}
