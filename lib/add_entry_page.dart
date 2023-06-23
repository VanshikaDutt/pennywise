import 'package:flutter/material.dart';
import 'package:pennywise/constants/constants.dart';
import 'package:pennywise/helper_methods/date_time_extensions.dart';
import 'package:provider/provider.dart';

import 'database_helper.dart';
import 'entry.dart';
import 'enums/expense_type.dart';
import 'theme/theme.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({required this.databaseHelper, super.key});

  final DatabaseHelper databaseHelper;

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final _formKey = GlobalKey<FormState>();
  late int _value;
  late String _label;
  ExpenseType _type = ExpenseType.other;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newEntry = Entry(
        value: _value,
        label: _label,
        type: _type,
        date: _date,
      );

      // Save the newEntry to the database using the DatabaseHelper
      print(newEntry);
      var id = await widget.databaseHelper.saveEntry(newEntry);
      print("Saved entry with id: $id");

      Navigator.pop(context); // Navigate back to the previous page
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: context.watch<AppThemeProvider>().appTheme.secondary,
            ),
            textTheme: TextTheme(
              subtitle1: TextStyle(
                  color: context.watch<AppThemeProvider>().appTheme.secondary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.watch<AppThemeProvider>().appTheme;
    var inputBorder =
        UnderlineInputBorder(borderSide: BorderSide(color: appTheme.secondary));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.secondary,
        title: const Text('Add Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: appTheme.secondary,
                decoration: InputDecoration(
                  icon: Icon(Icons.currency_rupee, color: appTheme.secondary),
                  labelStyle: TextStyle(color: appTheme.secondary),
                  labelText: AppStrings.moneySpent,
                  focusedBorder: inputBorder,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.emptyValueErrMsg;
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return AppStrings.invalidMoneyErrMsg;
                  }
                  return null;
                },
                onSaved: (value) => _value = int.parse(value!),
              ),
              TextFormField(
                cursorColor: appTheme.secondary,
                decoration: InputDecoration(
                  icon: Icon(Icons.note, color: appTheme.secondary),
                  labelStyle: TextStyle(color: appTheme.secondary),
                  labelText: AppStrings.expenseLabel,
                  focusedBorder: inputBorder,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.emptyValueErrMsg;
                  }
                  return null;
                },
                onSaved: (value) => _label = value!,
              ),
              DropdownButtonFormField<ExpenseType>(
                dropdownColor: appTheme.primary,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_tree_outlined,
                      color: appTheme.secondary),
                  labelText: 'Type',
                  labelStyle: TextStyle(color: appTheme.secondary),
                  focusedBorder: inputBorder,
                ),
                value: _type,
                onChanged: (value) => setState(() => _type = value!),
                items: ExpenseType.values.map((type) {
                  return DropdownMenuItem<ExpenseType>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(type.icon),
                        const SizedBox(width: 8.0),
                        Text(type.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
              GestureDetector(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today, color: appTheme.secondary),
                    labelText: 'Date',
                    labelStyle: TextStyle(color: appTheme.secondary),
                    focusedBorder: inputBorder,
                  ),
                  child: Text(_date.format_dd_MM_yyyy),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        backgroundColor: appTheme.secondary,
        foregroundColor: appTheme.primary,
        onPressed: _submitForm,
        label: const Text('Save'),
      ),
    );
  }
}
