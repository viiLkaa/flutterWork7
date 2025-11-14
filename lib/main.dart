import 'package:flutter/material.dart';
import 'features/task_managment/screens/task_home_screen.dart';

void main() {
  runApp(TaskTrackerApp());
}

class TaskTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF2E2E2E),
        appBarTheme: AppBarTheme(
          color: Color(0xFF1F1F1F),
          elevation: 1,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF3A3A3A),
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white70),
        ),
      ),
      // Только страничная навигация — без routes
      home: TaskHomeScreen(),
    );
  }
}
