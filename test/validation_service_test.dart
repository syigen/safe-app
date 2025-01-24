import 'package:flutter_test/flutter_test.dart';
import 'package:safe_app/services/validation_service.dart';

void main() {
  group('ValidationService', () {
    // Test if a password with 8 or more characters passes validation
    test('should return true if password has at least 8 characters', () {
      expect(ValidationService.hasEightChars('12345678'), isTrue);
    });

    // Test if a password with less than 8 characters fails validation
    test('should return false if password has less than 8 characters', () {
      expect(ValidationService.hasEightChars('12345'), isFalse);
    });

    // Test if a password containing at least one digit passes validation
    test('should return true if password contains at least one digit', () {
      expect(ValidationService.hasOneDigit('password1'), isTrue);
    });

    // Test if a password without any digits fails validation
    test('should return false if password does not contain any digits', () {
      expect(ValidationService.hasOneDigit('password'), isFalse);
    });

    // Test if a password containing at least one letter passes validation
    test('should return true if password contains at least one letter', () {
      expect(ValidationService.hasOneLetter('1234a567'), isTrue);
    });

    // Test if a password without any letters fails validation
    test('should return false if password does not contain any letters', () {
      expect(ValidationService.hasOneLetter('12345678'), isFalse);
    });

    // Test if a properly formatted email passes validation
    test('should return true for a valid email', () {
      expect(ValidationService.isValidEmail('test@example.com'), isTrue);
    });

    // Test if an email missing the "@" symbol fails validation
    test('should return false for an email without "@"', () {
      expect(ValidationService.isValidEmail('testexample.com'), isFalse);
    });

    // Test if an email missing the domain fails validation
    test('should return false for an email without a domain', () {
      expect(ValidationService.isValidEmail('test@'), isFalse);
    });

    // Test if an email missing the username fails validation
    test('should return false for an email without a username', () {
      expect(ValidationService.isValidEmail('@example.com'), isFalse);
    });

    // Test if an email containing invalid characters fails validation
    test('should return false for an email with invalid characters', () {
      expect(ValidationService.isValidEmail('test!@example.com'), isFalse);
    });

    // Test if an empty email fails validation
    test('should return false for an empty email', () {
      expect(ValidationService.isValidEmail(''), isFalse);
    });
  });
}
