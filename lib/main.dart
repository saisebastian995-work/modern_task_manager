import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/task.dart';
import 'services/app_settings.dart';
import 'services/task_store.dart';
import 'ui/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  await TaskStore.init();
  await AppSettings.init();

  runApp(const TaskApp());
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  late bool _dark = AppSettings.isDark();

  Future<void> _toggleTheme() async {
    setState(() => _dark = !_dark);
    await AppSettings.setDark(_dark);
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6C63FF),
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Tasks',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(isDark: _dark, onToggleTheme: _toggleTheme),
    );
  }
}
