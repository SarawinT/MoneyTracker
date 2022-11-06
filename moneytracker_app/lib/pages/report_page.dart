import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:moneytracker_app/models/dated_transaction.dart';
import 'package:moneytracker_app/widgets/custom_app_bar_content.dart';
import 'package:moneytracker_app/widgets/report_card.dart';

import '../appdata.dart';
import '../services/api.dart';
import '../widgets/app_drawer.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late String dateTimeText = "";
  late List<dynamic> datedTransactions = ["Loading..."];
  double sumIncome = 0;
  double sumExpense = 0;

  @override
  void initState() {
    AppData.startDate = DateTime.now();
    AppData.startDate = DateTime.parse(
        "${AppData.startDate.year}-${AppData.startDate.month}-01");
    dateTimeText = DateFormat("MMMM yyyy").format(AppData.startDate);
    AppData.endDate = Jiffy(Jiffy(AppData.startDate).add(months: 1).dateTime)
        .subtract(days: 1)
        .dateTime;
    updateData();
    super.initState();
  }

  void updateData() async {
    sumIncome = 0;
    sumExpense = 0;
    datedTransactions = await API.getTransactionsFromDateRange(
        DateFormat("yyyy-MM-dd").format(AppData.startDate),
        DateFormat("yyyy-MM-dd").format(AppData.endDate));
    for (DatedTransaction datedTransaction in datedTransactions) {
      sumIncome += datedTransaction.getTotalIncome();
      sumExpense += datedTransaction.getTotalExpense();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBarContent(),
      ),
      drawer: const AppDrawer(
        pageIndex: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      AppData.startDate =
                          Jiffy(AppData.startDate).subtract(months: 1).dateTime;
                      AppData.endDate = Jiffy(
                              Jiffy(AppData.startDate).add(months: 1).dateTime)
                          .subtract(days: 1)
                          .dateTime;
                      setState(() {
                        dateTimeText =
                            DateFormat("MMMM yyyy").format(AppData.startDate);
                      });
                      updateData();
                    },
                    icon: const Icon(Icons.chevron_left),
                    splashRadius: 22),
                SizedBox(
                  width: 156,
                  child: Text(
                    dateTimeText,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF005E08)),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      AppData.startDate =
                          Jiffy(AppData.startDate).add(months: 1).dateTime;
                      AppData.endDate = Jiffy(
                              Jiffy(AppData.startDate).add(months: 1).dateTime)
                          .subtract(days: 1)
                          .dateTime;
                      setState(() {
                        dateTimeText =
                            DateFormat("MMMM yyyy").format(AppData.startDate);
                      });
                      updateData();
                    },
                    icon: const Icon(Icons.chevron_right),
                    splashRadius: 22),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Report from ",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${DateFormat("dd MMM yyyy").format(AppData.startDate)} "
                  "- ${DateFormat("dd MMM yyyy").format(AppData.endDate)}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: ReportCard(
                  isIncome: true,
                  amount: sumIncome,
                )),
                Expanded(
                    child: ReportCard(
                  isIncome: false,
                  amount: sumExpense,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
