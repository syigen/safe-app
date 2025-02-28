// ignore_for_file: use_build_context_synchronously

/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_app/pages/loading_page.dart';
import 'package:safe_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

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
        if (error.message
            .contains('Password should be at least 6 characters')) {
          return 'Password should be at least 6 characters long.';
        }
        return 'Invalid input. Please check your details and try again.';
      case '429':
        return 'Too many requests. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  // Method to save user data to local storage
  Future<void> saveUserData(String userId) async {
    try {
      final userData = await supabase
          .from('profiles')
          .select('full_name, is_admin')
          .eq('id', userId)
          .single();

      final String userName = userData['full_name'] as String? ?? '';
      final bool isAdmin = userData['is_admin'] as bool? ?? false;

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setBool('isAdmin', isAdmin);
      await prefs.setString('userName', userName);
      await prefs.setString('userId', userId);
    } catch (e) {
      _showToast(
        message: 'Failed to save user data: $e',
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  }

  // Method to re-fetch and update user data
  Future<void> refreshUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) {
      return;
    }

    try {
      final userData = await supabase
          .from('profiles')
          .select('full_name, is_admin')
          .eq('id', userId)
          .single();

      final String userName = userData['full_name'] as String? ?? '';
      final bool isAdmin = userData['is_admin'] as bool? ?? false;

      // Update local storage
      await prefs.setBool('isAdmin', isAdmin);
      await prefs.setString('userName', userName);
    } catch (e) {
      debugPrint('Failed to refresh user data: $e');
    }
  }

  // Method to get user admin status
  Future<bool> getUserAdminStatus() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        _showToast(
          message: 'No user is logged in. Please login first.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }

      final response = await Supabase.instance.client
          .from('profiles')
          .select('is_admin')
          .eq('id', user.id)
          .single();

      return response['is_admin'] ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user admin status: $e');
      }
      _showToast(
        message: 'Failed to retrieve user admin status. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  // Check if user has name and avatar
  Future<bool> hasProfileData() async {
    try {
      final profile = await getUserProfile();

      if (profile == null) {
        return false;
      }

      final String fullName = profile['fullName'] as String;
      final String avatarUrl = profile['avatarUrl'] as String;

      return fullName.isNotEmpty || avatarUrl.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking profile data: $e');
      }
      return false;
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
        final userId = response.user?.id;

        if (userId != null) {
          // Save user data to local storage
          await saveUserData(userId);

          // Print the isAdmin value after saving to local storage
          final prefs = await SharedPreferences.getInstance();
          final bool? isAdmin = prefs.getBool('isAdmin');
          if (kDebugMode) {
            print('Is Admin: $isAdmin');
          }

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
            message: 'Failed to get user information.',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
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
        message: 'An unexpected error occurred. Error: $e.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('isAdmin');
      await prefs.remove('userName');
      await prefs.remove('userId');

    } catch (e) {
      _showToast(
        message: 'Error logging out. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      debugPrint('Error logging out: $e');
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
      if (kDebugMode) {
        print('Email or password is empty');
      }
      _showToast(
        message: 'Email and password cannot be empty.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (!hasEightChars || !hasOneDigit || !hasOneLetter) {
      if (kDebugMode) {
        print('Password does not meet the required conditions');
      }
      _showToast(
        message: 'Password must have at least 8 characters, one digit, and one letter.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      if (kDebugMode) {
        print('Attempting to register user with email: $email');
      }
      final response = await authClient.register(email, password);

      if (response.user != null) {
        if (kDebugMode) {
          print('Registration successful! User: ${response.user!.email}');
        }

        _showToast(
          message: 'Registration successful!',
          backgroundColor: const Color(0xFF00DF81),
          textColor: Colors.white,
        );

        // Navigate to the login page after successful registration.
        if (kDebugMode) {
          print('Navigating to LoginPage');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        if (kDebugMode) {
          print('Registration failed, no user returned in response');
        }
        _showToast(
          message: 'Registration failed. Please try again.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('Caught AuthException: ${e.message}, StatusCode: ${e.statusCode}');
      }
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
      if (kDebugMode) {
        print('Caught unexpected error: $e');
      }
      _showToast(
        message: 'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> updateProfile({
    String? newName,
    File? newAvatar,
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        _showToast(
          message: 'No user is logged in. Please login first.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      if (kDebugMode) {
        print('User found: ${user.id}');
      }

      final profileUpdates = <String, dynamic>{};

      if (newName != null && newName.isNotEmpty) {
        profileUpdates['full_name'] = newName;
        if (kDebugMode) {
          print('Name update detected: $newName');
        }
      }

      if (newAvatar != null) {
        if (kDebugMode) {
          print('Avatar update detected. Uploading avatar...');
        }
        final avatarUrl = await _uploadAvatarToStorage(newAvatar);

        if (avatarUrl != null) {
          profileUpdates['avatar_url'] = avatarUrl;
          if (kDebugMode) {
            print('Avatar uploaded successfully: $avatarUrl');
          }
        } else {
          if (kDebugMode) {
            print('Failed to upload avatar.');
          }
        }
      }

      if (profileUpdates.isNotEmpty) {
        await Supabase.instance.client
            .from('profiles')
            .update(profileUpdates)
            .eq('id', user.id);

        _showToast(
          message: 'Profile updated successfully!',
          backgroundColor: const Color(0xFF00DF81),
          textColor: Colors.white,
        );

        if (kDebugMode) {
          print('Profile update completed: $profileUpdates');
        }
      }

    } catch (e) {
      _showToast(
        message: 'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      if (kDebugMode) {
        print('Error during profile update: $e');
      }
    }
  }

  Future<String?> _uploadAvatarToStorage(File avatarFile) async {
    try {
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      if (kDebugMode) {
        print('Uploading avatar with filename: $fileName');
      }

      await Supabase.instance.client.storage
          .from('avatars')
          .upload(fileName, avatarFile);

      final avatarUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(fileName);

      if (kDebugMode) {
        print('Avatar URL: $avatarUrl');
      }
      return avatarUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading avatar: $e');
      }
      return null;
    }
  }

  void showToast({
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    if (kDebugMode) {
      print(message);
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        _showToast(
          message: 'No user is logged in. Please login first.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }

      final response = await Supabase.instance.client
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', user.id)
          .single();

      // Return the profile data
      return {
        'fullName': response['full_name'] ?? '',
        'avatarUrl': response['avatar_url'] ?? '',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
      _showToast(
        message: 'Failed to retrieve user profile. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }
}
