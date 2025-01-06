import 'package:flutter/material.dart';
import '../widgets/social_login_button.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  bool _obscureText = true;
  String _password = '';

  bool get hasEightChars => _password.length >= 8;
  bool get hasOneDigit => _password.contains(RegExp(r'[0-9]'));
  bool get hasOneLetter => _password.contains(RegExp(r'[a-zA-Z]'));

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
                  'Register',
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
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00FF9D)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  obscureText: _obscureText,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: hasEightChars
                            ? const Color(0xFF00FF9D)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color:
                        hasOneDigit ? const Color(0xFF00FF9D) : Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: hasOneLetter
                            ? const Color(0xFF00FF9D)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _validationItem('Has at least 8 characters?', hasEightChars),
              const SizedBox(height: 8),
              _validationItem('Has one digit?', hasOneDigit),
              const SizedBox(height: 8),
              _validationItem('Has one letter?', hasOneLetter),
              const SizedBox(height: 24),
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
                  'Register',
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
                    "Already registered? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Login Now',
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

  Widget _validationItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          color: isValid ? const Color(0xFF00FF9D) : Colors.white54,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? const Color(0xFF00FF9D) : Colors.white54,
          ),
        ),
      ],
    );
  }
}
