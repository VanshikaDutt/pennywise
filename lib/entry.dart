import 'enums/expense_type.dart';

class Entry {
  int id;
  int value;
  String label;
  ExpenseType type;
  DateTime date;

  Entry({
    this.id = 0,
    required this.value,
    required this.label,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'label': label,
      'type': type.name,
      'date': date.millisecondsSinceEpoch,
    };
  }

  static Entry fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'],
      value: map['value'],
      label: map['label'],
      type: _getTypeFromName(map['type']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  static ExpenseType _getTypeFromName(String typeName) {
    for (var type in ExpenseType.values) {
      if (type.name == typeName) {
        return type;
      }
    }
    return ExpenseType.other;
  }

  @override
  String toString() {
    return 'Entry{value: $value, label: $label, type: $type, date: $date}';
  }
}
