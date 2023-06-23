import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pennywise/add_entry_page.dart';
import 'package:pennywise/database_helper.dart';
import 'package:pennywise/edit_entry_page.dart';
import 'package:pennywise/helper_methods/string_extensions.dart';
import 'package:provider/provider.dart';

import 'entry.dart';
import 'entry_chart_page.dart';
import 'theme/theme.dart';

class EntriesPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const EntriesPage({required this.databaseHelper, Key? key}) : super(key: key);

  @override
  State<EntriesPage> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.watch<AppThemeProvider>().appTheme.primary.withOpacity(0.8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.watch<AppThemeProvider>().appTheme.secondary,
        title: const Text('Entries'),
        actions: [
          IconButton(
              onPressed: () => context.read<AppThemeProvider>().cycleTheme(),
              icon: const Icon(Icons.contrast)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryChartPage(widget.databaseHelper),
                  ),
                );
              },
              icon: const Icon(Icons.bar_chart)),
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEntryPage(
                            databaseHelper: widget.databaseHelper,
                          )),
                );
                setState(() {});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Entry>>(
          future: widget.databaseHelper.getEntries(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              print(snapshot.data?.length.toString());
              List<Entry> entries = snapshot.data!;
              if (entries.isEmpty) {
                return Text(
                  'No Entries Found',
                  style: TextStyle(
                      fontSize: 24,
                      color:
                          context.watch<AppThemeProvider>().appTheme.secondary),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: SlidableAutoCloseBehavior(
                  child: ListView.separated(
                    itemCount: entries.length,
                    itemBuilder: (context, index) =>
                        _buildListTile(entries[index]),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  String _formattedDate(DateTime date) {
    final months = [
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
    return "${date.day} ${months[date.month - 1]}, ${date.year}";
  }

  Widget _buildListTile(Entry entry) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Slidable(
        key: ValueKey(entry),
        direction: Axis.horizontal,
        groupTag: "entries",
        closeOnScroll: true,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _deleteEntry(entry),
              // backgroundColor: const Color(0xFFFE4A49),
              // foregroundColor: Colors.white,
              backgroundColor:
                  context.watch<AppThemeProvider>().appTheme.secondary,
              foregroundColor:
                  context.watch<AppThemeProvider>().appTheme.primary,
              icon: Icons.delete,
              label: 'Delete',
            ),
            const SizedBox(width: 2),
            SlidableAction(
              onPressed: (_) => _navigateToEdit(entry),
              // backgroundColor: const Color(0xFF21B7CA),
              // foregroundColor: Colors.white,
              backgroundColor:
                  context.watch<AppThemeProvider>().appTheme.secondary,
              foregroundColor:
                  context.watch<AppThemeProvider>().appTheme.primary,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: context.watch<AppThemeProvider>().appTheme.secondary,
          ),
          padding: const EdgeInsets.fromLTRB(0, 1.5, 2.5, 1.5),
          child: Container(
            decoration: BoxDecoration(
                color: context.watch<AppThemeProvider>().appTheme.primary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: ListTile(
              title: Text(
                entry.label.titleCase,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
              subtitle: Row(
                children: [
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    color: context.watch<AppThemeProvider>().appTheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 2),
                      child: Text(
                        _formattedDate(entry.date),
                        style: TextStyle(
                          color: context
                              .watch<AppThemeProvider>()
                              .appTheme
                              .primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              leading: Icon(entry.type.icon,
                  color: context.watch<AppThemeProvider>().appTheme.secondary),
              trailing: Card(
                elevation: 0,
                color: context.watch<AppThemeProvider>().appTheme.secondary,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    "\$ ${entry.value}",
                    style: TextStyle(
                      fontSize: 18,
                      color: context.watch<AppThemeProvider>().appTheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _navigateToEdit(Entry entry) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditEntryPage(entry: entry, databaseHelper: widget.databaseHelper),
      ),
    );
    setState(() {});
  }

  Future<void> _deleteEntry(Entry entry) async {
    widget.databaseHelper
        .deleteEntry(entry.id)
        .then((value) => setState(() {}));
  }
}
