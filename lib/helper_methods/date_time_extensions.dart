const monthNames = [
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

extension DateTimeAppFormat on DateTime {
  String get format_MM_yyyy => '${monthNames[month - 1]}, $year';

  String get format_dd_MM_yyyy => '$day ${monthNames[month - 1]}, $year';
}
