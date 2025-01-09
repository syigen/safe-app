import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/auth/authService.dart';
import '../lib/auth/auth_service.dart';

void main() {
  late AuthService authService;

  setUpAll(() async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://rgfjdrewojyyvpaurzhg.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJnZmpkcmV3b2p5eXZwYXVyemhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzMDczMTgsImV4cCI6MjA1MTg4MzMxOH0.cqve0BwJbCzwPngcDKE9nxJ61IBG-92Ggt-d0wvh7iM',
    );
  });

  setUp(() {
    authService = AuthService();
  });

  group('AuthService Login Tests', () {
    testWidgets('Successful Login', (WidgetTester tester) async {
      // Mock credentials
      const email = 'test@example.com';
      const password = 'test@123';

      // Build the widget tree
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              // Run the login function
              authService.login(
                context: context,
                email: email,
                password: password,
              );
              return Container(); // An empty widget
            },
          ),
        ),
      ));

      // Simulate widget updates
      await tester.pump();

      // Assertions (if any)
      expect(find.byType(SnackBar), findsOneWidget); // Check if SnackBar appears
    });
  });
}
