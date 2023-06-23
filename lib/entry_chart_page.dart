import 'package:flutter/material.dart';
import 'package:pennywise/database_helper.dart';
import 'package:pennywise/entry.dart';
import 'package:provider/provider.dart';

import 'chart_page.dart';
import 'theme/theme.dart';

class EntryChartPage extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const EntryChartPage(this.databaseHelper, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.watch<AppThemeProvider>().appTheme.secondary,
        title: const Text('Monthly Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: FutureBuilder<Map<DateTimeLabel, List<Entry>>>(
          future: groups(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var keys =
              snapshot.data
              !.keys.toList();
              return ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount:
                snapshot.data?.keys.length
                    ?? 0,
                itemBuilder: (context, index) {
                  final k = keys[index];
                  final v =
                  snapshot.data
                  ![k]!.fold(
                      0,
                          (previousValue, element) =>
                      previousValue + element.value);
                  var isCurrentMonthAndYear = k.month ==
                      DateTime.now
                        ().month &&
                      k.year ==
                          DateTime.now
                            ().year;
                  var listTile = ListTile(
                    title: Text(k.toString()),
                    trailing: Text("\$ $v"),
                    subtitle: isCurrentMonthAndYear
                        ? Row(
                      children: [
                        Card(
                          margin:
                          EdgeInsets.zero
                          ,
                          color: context
                              .watch<AppThemeProvider>()
                              .appTheme
                              .secondary,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            child: Text(
                              "Current Month",
                              style: TextStyle(
                                fontSize: 10,
                                color: context
                                    .watch<AppThemeProvider>()
                                    .appTheme
                                    .primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChartPage(
                              "${k.toString()} Expenses",
                              snapshot.data
                              ![k]!),
                        ),
                      );
                    },
                  );
                  return Container(
                    padding: const EdgeInsets.fromLTRB(2.5, 2.5, 2.5, 5.5),
                    decoration: BoxDecoration(
                      color:
                      context.watch<AppThemeProvider>().appTheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                        context.watch<AppThemeProvider>().appTheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: listTile,
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<Map<DateTimeLabel, List<Entry>>> groups() async {
    final entries = await databaseHelper.getEntries();
    Map<DateTimeLabel, List<Entry>> map = {};
    for (var e in entries) {
      DateTimeLabel dtl = DateTimeLabel(
          e.date
      );
      map.putIfAbsent(dtl, () => []);
      map[dtl]!.add(e);
    }
    print("----------------");
    var sortedKeys = map.keys.toList()
      ..sort(
            (a, b) {
          if (a.year == b.year) {
            return a.month - b.month;
          } else {
            return a.year - b.year;
          }
        },
      );
    Map<DateTimeLabel, List<Entry>> sortedMapByKeys =
    Map.fromEntries(
        sortedKeys.map
          ((key) => MapEntry(key, map[key]!)));
    print(sortedMapByKeys);

    return sortedMapByKeys;
  }
}

class DateTimeLabel {
  final int year, month;

  DateTimeLabel(DateTime dateTime)
      : year = dateTime.year,
        month = dateTime.month;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DateTimeLabel &&
              runtimeType == other.runtimeType &&
              year == other.year &&
              month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  @override
  String toString() {
    final monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return '${monthNames[month - 1]}, $year';
  }
}