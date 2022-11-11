import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneytracker_app/models/dated_transaction_amount.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DateChart extends StatefulWidget {
  final List<DatedTransactionAmount> incomes;
  final List<DatedTransactionAmount> expenses;
  const DateChart({Key? key, required this.incomes, required this.expenses})
      : super(key: key);

  @override
  State<DateChart> createState() => _DateChartState();
}

class _DateChartState extends State<DateChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableSideBySideSeriesPlacement: false,
      primaryXAxis: CategoryAxis(labelStyle: GoogleFonts.kanit()),
      primaryYAxis: NumericAxis(labelStyle: GoogleFonts.kanit()),
      series: <ChartSeries<DatedTransactionAmount, String>>[
        ColumnSeries<DatedTransactionAmount, String>(
            color: Colors.blueAccent,
            dataSource: widget.incomes,
            xValueMapper: (DatedTransactionAmount data, _) => data.date,
            yValueMapper: (DatedTransactionAmount data, _) => data.amount,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: GoogleFonts.kanit(color: const Color(0xFF0037AB)),
                showZeroValue: false)),
        ColumnSeries<DatedTransactionAmount, String>(
            color: Colors.redAccent,
            dataSource: widget.expenses,
            xValueMapper: (DatedTransactionAmount data, _) => data.date,
            yValueMapper: (DatedTransactionAmount data, _) => data.amount,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: GoogleFonts.kanit(color: const Color(0xFFAB0000)),
                showZeroValue: false))
      ],
    );
  }
}
