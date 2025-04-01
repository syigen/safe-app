import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_app/pages/welcome_page.dart';

import '../services/auth_service.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  VerificationScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthService _authService = AuthService(authClient: SupabaseAuthClient());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendTimer = 60;
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Add listeners to handle focus and input changes
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[i].text.length),
          );
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _moveToNextField(int currentIndex) {
    if (currentIndex < 5 && _controllers[currentIndex].text.isNotEmpty) {
      FocusScope.of(context).requestFocus(_focusNodes[currentIndex + 1]);
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

  Future<void> _verifyOTP() async {
    String otp = _controllers.map((controller) => controller.text).join();
    debugPrint(otp);
    await _authService.verifyOTP(context: context, phoneNumber: widget.phoneNumber, otp: otp);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents the bottom overflow
      backgroundColor: const Color(0xFF021B1A),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Existing widgets remain the same...
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF7F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.verified_sharp,
                        size: 70,
                        color: Color(0xFF00DF81),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Verify your phone number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF1F7F6),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'We\'ve sent an SMS with a verification code to your phone ${'0${widget.phoneNumber.replaceAll('+94', '')}'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                            (index) => RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (RawKeyEvent event) {
                            if (event is RawKeyDownEvent) {
                              if (event.logicalKey == LogicalKeyboardKey.backspace) {
                                if (_controllers[index].text.isEmpty && index > 0) {
                                  // Move focus to previous field and clear it
                                  _focusNodes[index - 1].requestFocus();
                                  _controllers[index - 1].clear();
                                }
                              }
                            }
                          },
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                showCursor: false,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                  color: Color(0xFF00DF81),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF00DF81),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  // Programmatically move to next field if needed
                                  if (value.length == 1) {
                                    _moveToNextField(index);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Rest of the existing widgets remain the same
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        _verifyOTP();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00DF81),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF021B1A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _resendTimer == 0
                          ? () {
                        setState(() => _resendTimer = 60);
                        _startTimer();
                        _authService.requestOTP(context: context, phoneNumber: widget.phoneNumber);
                      }
                          : null,
                      child: Text(
                        _resendTimer == 0 ? 'Resend Code' : 'Resend Code ($_resendTimer s)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _resendTimer == 0 ? const Color(0xFF00DF81) : const Color(0xFFB6B6B6),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF00DF81),
                        size: 16,
                      ),
                      label: const Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xFF00DF81),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}