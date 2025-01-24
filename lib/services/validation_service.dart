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
}
