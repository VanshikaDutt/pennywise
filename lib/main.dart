import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'database_helper.dart';
import 'entries_page.dart';
import 'fake_data.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DatabaseHelper databaseHelper = DatabaseHelper();
  await databaseHelper.initDb();

  if (kDebugMode || kProfileMode) {
    await databaseHelper.deleteAllEntries();
    for (var e in fakeEntries) {
      await databaseHelper.saveEntry(e);
    }
  }

  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MyApp({required this.databaseHelper, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppThemeProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: EntriesPage(databaseHelper: databaseHelper),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: SafeArea(child: child!),
        ),
      ),
    );
  }
}
