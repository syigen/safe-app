import 'package:flutter/material.dart';
import 'package:safe_app/pages/loading_page.dart';
import 'package:safe_app/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Abstracting the Supabase client interaction
abstract class AuthClient {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(String email, String password);
}

class SupabaseAuthClient implements AuthClient {
  @override
  Future<AuthResponse> login(String email, String password) async {
    return Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> register(String email, String password) async {
    return Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
  }
}

class AuthService {
  final AuthClient authClient;

  AuthService({required this.authClient});

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email and password cannot be empty.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await authClient.login(email, password);

      if (response.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoadingPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required bool hasEightChars,
    required bool hasOneDigit,
    required bool hasOneLetter,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email and password cannot be empty.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!hasEightChars || !hasOneDigit || !hasOneLetter) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must have at least 8 characters, one digit, and one letter.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await authClient.register(email, password);

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}