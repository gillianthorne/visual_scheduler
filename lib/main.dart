import 'package:flutter/material.dart';

void main() {
  runApp(const VisualSchedulerApp());
}

class VisualSchedulerApp extends StatelessWidget {
  const VisualSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visual Scheduler',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Visual Scheduler'),
        ),
      ),
    );
  }
}
