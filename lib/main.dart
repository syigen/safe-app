import 'package:flutter/material.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const SafeApp());
}

class SafeApp extends StatelessWidget {
  const SafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe App',
      theme: ThemeData.dark(),
      home: const LandingPage(),
    );
  }
}
