import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/google_maps_page.dart'; // Make sure to import your screen

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps with Riverpod',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleMapsScreen(),
    );
  }
}
