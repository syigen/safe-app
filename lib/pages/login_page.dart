/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:safe_app/pages/forgot_password_page.dart';
import 'package:safe_app/pages/registration_page.dart';
import 'package:safe_app/services/auth_service.dart';
import '../widgets/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService(authClient: SupabaseAuthClient());

  // Add focus nodes for each text field
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add listeners to update the UI when focus changes
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose focus nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              SocialLoginButton(
                text: 'Continue with Google',
                iconPath: 'assets/logo/google.png',
                onTap: () {
                  // Add Google login functionality here
                },
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                text: 'Continue with Facebook',
                iconPath: 'assets/logo/facebook.png',
                onTap: () {
                  // Add Facebook login functionality here
                },
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                text: 'Continue with Apple',
                iconPath: 'assets/logo/apple.png',
                onTap: () {
                  // Add Apple login functionality here
                },
              ),
              const SizedBox(height: 32),

              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white38)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or better yet',
                      style: TextStyle(color: Color(0XFFF1F7F6 )),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white38)),
                ],
              ),
              const SizedBox(height: 32),

              // Email Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _emailFocusNode.hasFocus
                        ? const Color(0xFF00FF81)
                        : const Color(0xFF03624C),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  focusNode: _emailFocusNode,
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Color(0xFFAACBC4)),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: _emailFocusNode.hasFocus
                          ? const Color(0xFF00FF81)
                          : const Color(0xFFAACBC4),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field with Forgot Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _passwordFocusNode.hasFocus
                            ? const Color(0xFF00FF81)
                            : const Color(0xFF03624C),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      focusNode: _passwordFocusNode,
                      controller: passwordController,
                      obscureText: _obscureText,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xFFAACBC4)),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: _passwordFocusNode.hasFocus
                              ? const Color(0xFF00FF81)
                              : Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: _passwordFocusNode.hasFocus
                                ? const Color(0xFF00FF81)
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Color(0xFF00FF81),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  _authService.login(
                    context: context,
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF81),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Color(0xFFF1F7F6 )),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        color: Color(0xFF00FF81),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}