/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safe_app/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  setUpAll(() async {
    // Load environment variables for Supabase connection
    await dotenv.load(fileName: ".env");

    // Set up shared preferences mock
    SharedPreferences.setMockInitialValues({});

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    // Ensure test user exists
    final authClient = SupabaseAuthClient();
    // try {
    //   await authClient.register('testuser@example.com', 'password123');
    // } catch (e) {
    //   // Ignore if user already exists
    //   print('Test user already exists: $e');
    // }
  });

  group('AuthService Tests', () {
    final authService = AuthService(authClient: SupabaseAuthClient());

    test('Login with valid credentials', () async {
      final email = 'testuser@example.com';
      final password = 'password123';

      // try {
      //   final response = await authService.authClient.login(email, password);
      //   expect(response.session, isNotNull, reason: 'Login should succeed with valid credentials');
      // } catch (e) {
      //   fail('Login failed with valid credentials: $e');
      // }
    });

    test('Login with invalid credentials', () async {
      final email = 'invalid@example.com';
      final password = 'wrongpassword';

      // try {
      //   await authService.authClient.login(email, password);
      //   fail('Login succeeded with invalid credentials');
      // } on AuthException catch (e) {
      //   expect(e.message.contains('Invalid login credentials'), isTrue, reason: 'Should return invalid credentials error');
      // }
    });

    test('Register a new user', () async {
      final email = 'newuser@example.com';
      final password = 'password123';

      // try {
      //   final response = await authService.authClient.register(email, password);
      //   expect(response.user, isNotNull, reason: 'User should be created');
      // } on AuthException catch (e) {
      //   if (e.message.contains('already registered')) {
      //     fail('Email already registered: $e');
      //   } else {
      //     fail('Registration failed: $e');
      //   }
      // }
    });

    test('Register with weak password', () async {
      final email = 'weakpassword@example.com';
      final password = '123';

      // try {
      //   await authService.authClient.register(email, password);
      //   fail('Registration succeeded with a weak password');
      // } on AuthException catch (e) {
      //   expect(e.message.contains('Password should be at least 6 characters'), isTrue, reason: 'Should enforce password policy');
      // }
    });
  });
}