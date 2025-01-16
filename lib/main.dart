import 'package:flutter/material.dart';
import 'package:safe_app/pages/landing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const SafeApp());
}

final supabase = Supabase.instance.client;

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