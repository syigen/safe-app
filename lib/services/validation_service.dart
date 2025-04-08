/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';

class ValidationService {
  static bool hasEightChars(String password) {
    return password.length >= 8;
  }

  static bool hasOneDigit(String password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  static bool hasOneLetter(String password) {
    return password.contains(RegExp(r'[a-zA-Z]'));
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^0\d{9}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}