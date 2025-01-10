import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_app/pages/loading_page.dart';
import 'package:safe_app/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  void _showToast({
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  String _getErrorMessage(AuthException error) {
    switch (error.statusCode) {
      case '400':
        if (error.message.contains('Invalid login credentials')) {
          return 'Invalid email or password. Please try again.';
        }
        return 'Invalid request. Please check your input and try again.';
      case '401':
        return 'Unauthorized. Please check your credentials.';
      case '422':
        if (error.message.contains('Password should be at least 6 characters')) {
          return 'Password should be at least 6 characters long.';
        }
        return 'Invalid input. Please check your details and try again.';
      case '429':
        return 'Too many requests. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _showToast(
        message: 'Email and password cannot be empty.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final response = await authClient.login(email, password);

      if (response.session != null) {
        _showToast(
          message: 'Login successful!',
          backgroundColor: const Color(0xFF00DF81),
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoadingPage()),
        );
      } else {
        _showToast(
          message: 'Login failed. Please check your credentials.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on AuthException catch (e) {
      _showToast(
        message: _getErrorMessage(e),
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      _showToast(
        message: 'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
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
      _showToast(
        message: 'Email and password cannot be empty.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (!hasEightChars || !hasOneDigit || !hasOneLetter) {
      _showToast(
        message: 'Password must have at least 8 characters, one digit, and one letter.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final response = await authClient.register(email, password);

      if (response.user != null) {
        _showToast(
          message: 'Registration successful!',
          backgroundColor: const Color(0xFF00DF81),
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        _showToast(
          message: 'Registration failed. Please try again.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on AuthException catch (e) {
      if (e.statusCode == '422' && e.message.contains('already registered')) {
        _showToast(
          message: 'This email is already registered. Please use a different email or try logging in.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        _showToast(
          message: _getErrorMessage(e),
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      _showToast(
        message: 'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
