import 'dart:math';

import 'entry.dart';
import 'enums/expense_type.dart';

final fakeEntries = [
  Entry(
    value: 100,
    label: "friends party",
    type: ExpenseType.entertainment,
    date: generateRandomDate(DateTime(2022, 1, 1), DateTime(2022, 6, 30)),
  ),
  Entry(
    value: 500,
    label: "restaurant dinner",
    type: ExpenseType.food,
    date: generateRandomDate(DateTime(2020, 1, 1), DateTime(2020, 6, 30)),
  ),
  Entry(
    value: 200,
    label: "movie tickets",
    type: ExpenseType.entertainment,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
  Entry(
    value: 50,
    label: "coffee with friends",
    type: ExpenseType.food,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
  Entry(
    value: 300,
    label: "weekend getaway",
    type: ExpenseType.travel,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
  Entry(
    value: 150,
    label: "grocery shopping",
    type: ExpenseType.food,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
  Entry(
    value: 50,
    label: "online streaming subscription",
    type: ExpenseType.entertainment,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
  Entry(
    value: 20,
    label: "bus fare",
    type: ExpenseType.travel,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
  Entry(
    value: 50,
    label: "magazine purchase",
    type: ExpenseType.other,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
  Entry(
    value: 200,
    label: "home decor",
    type: ExpenseType.other,
    date: generateRandomDate(DateTime(2023, 1, 1), DateTime(2023, 6, 30)),
  ),
];

DateTime generateRandomDate(DateTime startDate, DateTime endDate) {
  final random = Random();
  final dayDifference = endDate.difference(startDate).inDays;
  final randomDay = random.nextInt(dayDifference + 1);
  return startDate.add(Duration(days: randomDay));
}
