import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pennywise/entry.dart';
import 'package:pennywise/enums/expense_type.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'theme/theme.dart';

class ChartPage extends StatelessWidget {
  final List<Entry> entryList;
  final String title;

  const ChartPage(this.title, this.entryList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.watch<AppThemeProvider>().appTheme.secondary,
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: transformedEntryList(),
                    pointColorMapper: (entry, _) => getColor(entry.type),
                    xValueMapper: (entry, _) => entry.type.name,
                    yValueMapper: (entry, _) => entry.value,
                    explode: true,
                    radius: "95%",
                    dataLabelMapper: (datum, index) =>
                        "${datum.type.name} \$${datum.value}",
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        color:
                            context.watch<AppThemeProvider>().appTheme.primary,
                        fontSize: 18,
                      ),
                      color:
                          context.watch<AppThemeProvider>().appTheme.secondary,
                      opacity: 0.8,
                      labelIntersectAction: LabelIntersectAction.shift,
                      labelAlignment: ChartDataLabelAlignment.outer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                for (var e in ExpenseType.values)
                  LegendItemWidget(
                    label: e.name,
                    color: getColor(e),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getColor(ExpenseType expenseType) {
    Map<ExpenseType, Color> map = {
      ExpenseType.travel: Colors.blue,
      ExpenseType.food: Colors.red,
      ExpenseType.entertainment: Colors.green,
      ExpenseType.social: Colors.amber,
      ExpenseType.shopping: Colors.deepPurple,
      ExpenseType.education: Colors.blueGrey,
      ExpenseType.beauty: Colors.cyanAccent,
      ExpenseType.other: Colors.brown,
    };
    return map[expenseType] ?? Colors.black;
  }

  List<ChartData> transformedEntryList() {
    final Map<ExpenseType, int> map = {};
    for (var e in entryList) {
      map.putIfAbsent(e.type, () => 0);
      map[e.type] = map[e.type]! + e.value;
    }

    final data = <ChartData>[];
    map.entries.forEach((e) => data.add(ChartData(e.key, e.value)));
    return data;
  }
}

class LegendItemWidget extends StatelessWidget {
  final String label;
  final Color color;

  const LegendItemWidget({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class ChartData {
  final ExpenseType type;
  final int value;

  ChartData(this.type, this.value);
}
