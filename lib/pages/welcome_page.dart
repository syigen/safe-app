/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_app/pages/verification_page.dart';
import 'package:safe_app/services/auth_service.dart';
import 'package:safe_app/services/validation_service.dart';

// Welcome Page
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage>  {
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService(authClient: SupabaseAuthClient());

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Method to handle OTP request
  Future<void> _requestOTP() async {
    // Remove spaces from the phone number
    String phoneNumber = _phoneController.text.replaceAll(' ', '');

    if (phoneNumber.isEmpty || !ValidationService.isValidPhoneNumber(phoneNumber)) {
      _showToast(
        message: 'Please enter a valid phone number.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    phoneNumber = '+94${phoneNumber.substring(1)}';

    try {
      // Send OTP
      await _authService.requestOTP(context: context, phoneNumber: phoneNumber);

      // Navigate to OTP verification page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(phoneNumber: phoneNumber),
        ),
      );
    } catch (e) {
      // Handle any errors from OTP sending
      _showToast(
        message: 'Failed to send OTP. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Toast method
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use resizeToAvoidBottomInset to prevent bottom overflow
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          // This will dismiss the keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            const BackgroundImage(),
            SafeArea(
              child: SingleChildScrollView(
                // Make the content scrollable when keyboard appears
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        const LogoSection(),
                        const SizedBox(height: 20),
                        const WelcomeContent(),
                        const SizedBox(height: 40),
                        PhoneInputField(controller: _phoneController),
                        const SizedBox(height: 18),
                        ContinueButton(onPressed: _requestOTP),
                        // Add extra space at bottom to ensure button is visible with keyboard
                        SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ?
                        280 : 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Background Image
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/welcome_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Center Logo
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: const BoxDecoration(
          color: Color(0xFF00E676),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png', // You'll need this icon asset
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}

// Welcome Content
class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Stay connected with ease.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            'Enter your mobile number to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Phone Input Field
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fieldWidth = screenSize.width * 0.9;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Container(
        width: fieldWidth,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00DF81)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: InputBorder.none,
            hintText: 'Enter your mobile number',
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(
              Icons.phone,
              color: Color(0xFF00DF81),
            ),
          ),
          inputFormatters: [
            PhoneNumberFormatter()
          ],
        ),
      ),
    );
  }
}

// Continue Button
class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = screenSize.width * 0.9;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00DF81),
          foregroundColor: Colors.black,
          minimumSize: Size(buttonWidth, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Phone Number Formatter
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove any non-digit characters
    String cleaned = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 10 digits
    if (cleaned.length > 10) {
      cleaned = cleaned.substring(0, 10);
    }

    // Format the number
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      // Add space after 3rd and 6th digits
      if (i == 3 || i == 6) {
        formatted.write(' ');
      }
      formatted.write(cleaned[i]);
    }

    // Calculate cursor position
    int cursorPosition = newValue.selection.end;
    int newCursorPosition = cursorPosition + (formatted.length - cleaned.length);
    newCursorPosition = newCursorPosition.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}