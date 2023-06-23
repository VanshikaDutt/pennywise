import 'package:flutter/material.dart';
import 'package:pennywise/helper_methods/date_time_extensions.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'database_helper.dart';
import 'entry.dart';
import 'enums/expense_type.dart';
import 'theme/theme.dart';

class EditEntryPage extends StatefulWidget {
  final Entry entry;
  final DatabaseHelper databaseHelper;

  EditEntryPage({required this.entry, required this.databaseHelper});

  @override
  _EditEntryPageState createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  late TextEditingController _valueController;
  late TextEditingController _labelController;
  late ExpenseType _selectedType;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _valueController =
        TextEditingController(text: widget.entry.value.toString());
    _labelController = TextEditingController(text: widget.entry.label);
    _selectedType = widget.entry.type;
    _selectedDate = widget.entry.date;
  }

  @override
  void dispose() {
    _valueController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _updateEntry() async {
    final updatedEntry = Entry(
      value: int.parse(_valueController.text),
      label: _labelController.text,
      type: _selectedType,
      date: _selectedDate,
    );
    await widget.databaseHelper.updateEntry(widget.entry.id, updatedEntry);
    Navigator.pop(context); // Navigate back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppThemeProvider>().appTheme;
    final inputBorder =
        UnderlineInputBorder(borderSide: BorderSide(color: appTheme.secondary));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.watch<AppThemeProvider>().appTheme.secondary,
        title: const Text('Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _valueController,
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
            ),
            TextFormField(
              controller: _labelController,
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
              value: _selectedType,
              onChanged: (value) => setState(() => _selectedType = value!),
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
                child: Text(_selectedDate.format_dd_MM_yyyy),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        backgroundColor: appTheme.secondary,
        foregroundColor: appTheme.primary,
        onPressed: _updateEntry,
        label: const Text('Save'),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
