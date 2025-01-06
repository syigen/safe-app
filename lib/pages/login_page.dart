import 'package:flutter/material.dart';
import 'package:safe_app/pages/registration_page.dart';
import '../widgets/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

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
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Use the SocialLoginButton widget
              SocialLoginButton(
                text: 'Continue with Google',
                iconPath: 'assets/logo/google.png',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                text: 'Continue with Facebook',
                iconPath: 'assets/logo/facebook.png',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                text: 'Continue with Apple',
                iconPath: 'assets/logo/apple.png',
                onTap: () {},
              ),
              const SizedBox(height: 32),
              // Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white38)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or better yet',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white38)),
                ],
              ),
              const SizedBox(height: 32),
              // Email Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00FF9D)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon:
                    Icon(Icons.email_outlined, color: Color(0xFF00FF9D)),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00FF9D)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  obscureText: _obscureText,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: Color(0xFF00FF9D)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF00FF9D),
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
              const SizedBox(height: 24),
              // Login Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF9D),
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
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        color: Color(0xFF00FF9D),
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