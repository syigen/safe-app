/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_app/pages/loading_page.dart';
import 'package:safe_app/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

abstract class AuthClient {
  Future<void> sendOTP(String phoneNumber);
  Future<AuthResponse> verifyOTP(String phoneNumber, String token);
}

class SupabaseAuthClient implements AuthClient {
  @override
  Future<void> sendOTP(String phoneNumber) async {
    return Supabase.instance.client.auth.signInWithOtp(
      phone: phoneNumber,
    );
  }

  @override
  Future<AuthResponse> verifyOTP(String phoneNumber, String token) async {
    return Supabase.instance.client.auth.verifyOTP(
      phone: phoneNumber,
      token: token,
      type: OtpType.sms,
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
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  // Save user data to local storage
  Future<void> saveUserData(String userId) async {
    try {
      final userData = await supabase
          .from('profiles')
          .select('full_name, is_admin, phone_number')
          .eq('id', userId)
          .single();

      final String userName = userData['full_name'] as String? ?? '';
      final bool isAdmin = userData['is_admin'] as bool? ?? false;
      final String phone = userData['phone_number'] as String? ?? '';

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setBool('isAdmin', isAdmin);
      await prefs.setString('userName', userName);
      await prefs.setString('userId', userId);
      await prefs.setString('userPhone', phone);
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

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        await SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        return null;
      }

      final response = await Supabase.instance.client
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', user.id)
          .single();

      return {
        'fullName': response['full_name'] ?? '',
        'avatarUrl': response['avatar_url'] ?? '',
      };
    } catch (e) {
      if (e is AuthException) {
        await Supabase.instance.client.auth.signOut();
        await SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });
      }

      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }

      _showToast(
        message: 'Session expired. Please log in again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return null;
    }
  }

  // Request OTP for phone number authentication
  Future<void> requestOTP({
    required BuildContext context,
    required String phoneNumber,
  }) async {

    try {
      // Send OTP
      await authClient.sendOTP(phoneNumber);

      _showToast(
        message: 'OTP sent successfully!',
        backgroundColor: const Color(0xFF00DF81),
        textColor: Colors.white,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP and handle user authentication/registration
  Future<void> verifyOTP({
    required BuildContext context,
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await authClient.verifyOTP(phoneNumber, otp);

      if (response.session != null) {
        final user = response.user;
        if (user == null) {
          _showToast(
            message: 'Failed to get user information.',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        // Check if user profile exists
        bool profileExists = await _checkUserProfile(user.id);

        if (!profileExists) {
          await _createUserProfile(user.id, phoneNumber);
        }

        // Save user data to local storage
        await saveUserData(user.id);

        // Check admin status
        final prefs = await SharedPreferences.getInstance();
        final bool? isAdmin = prefs.getBool('isAdmin');
        if (kDebugMode) {
          print('Is Admin: $isAdmin');
          print('Profile Exists: $profileExists');
        }

        _showToast(
          message: profileExists ? 'Welcome back!' : 'Account created successfully!',
          backgroundColor: const Color(0xFF00DF81),
          textColor: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoadingPage()),
        );
      } else {
        _showToast(
          message: 'OTP verification failed.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      _showToast(
        message: 'Authentication failed. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      if (kDebugMode) {
        print('OTP Verification Error: $e');
      }
      rethrow;
    }
  }

  // Check if user profile exists
  Future<bool> _checkUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .single();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Create a new user profile
  Future<void> _createUserProfile(String userId, String phoneNumber) async {
    try {
      await supabase
          .from('profiles')
          .insert({
        'id': userId,
        'phone_number': phoneNumber,
        'is_admin': false,
        'full_name': '',
        'avatar_url': '',
        'created_at': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('New user profile created for phone number: $phoneNumber');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user profile: $e');
      }
      _showToast(
        message: 'Failed to create user profile.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('isLoggedIn');
      await prefs.remove('isAdmin');
      await prefs.remove('userName');
      await prefs.remove('userId');
      await prefs.remove('userPhone');

      await Supabase.instance.client.auth.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
            (route) => false,
      );

      _showToast(
        message: 'Logged out successfully.',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
            (route) => false,
      );

      _showToast(
        message: 'An error occurred during logout.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}