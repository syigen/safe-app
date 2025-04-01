// /*
//  * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
//  *
//  */
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../widgets/social_login_button.dart';
// import 'package:safe_app/services/auth_service.dart';
// import '../services/validation_service.dart';
//
// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({super.key});
//
//   @override
//   State<RegistrationPage> createState() => RegistrationPageState();
// }
//
// class RegistrationPageState extends State<RegistrationPage> {
//   bool _obscureText = true;
//   String _password = '';
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService _authService = AuthService(authClient: SupabaseAuthClient());
//
//   final FocusNode _emailFocusNode = FocusNode();
//   final FocusNode _passwordFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     _emailFocusNode.addListener(_onFocusChange);
//     _passwordFocusNode.addListener(_onFocusChange);
//   }
//
//   void _onFocusChange() {
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   void _showToast({
//     required String message,
//     required Color backgroundColor,
//     required Color textColor,
//   }) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.TOP,
//       backgroundColor: backgroundColor,
//       textColor: textColor,
//       fontSize: 16.0,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF021B1A),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 40),
//               const Center(
//                 child: Text(
//                   'Register',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 44,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//
//               // Social Login Buttons
//               SocialLoginButton(
//                 text: 'Continue with Google',
//                 iconPath: 'assets/logo/google.png',
//                 onTap: () {},
//               ),
//               const SizedBox(height: 16),
//               SocialLoginButton(
//                 text: 'Continue with Facebook',
//                 iconPath: 'assets/logo/facebook.png',
//                 onTap: () {},
//               ),
//               const SizedBox(height: 16),
//               SocialLoginButton(
//                 text: 'Continue with Apple',
//                 iconPath: 'assets/logo/apple.png',
//                 onTap: () {},
//               ),
//
//               const SizedBox(height: 32),
//               const Row(
//                 children: [
//                   Expanded(child: Divider(color: Colors.white38)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'Or better yet',
//                       style: TextStyle(color: Color(0xFFF1F7F6 )),
//                     ),
//                   ),
//                   Expanded(child: Divider(color: Colors.white38)),
//                 ],
//               ),
//               const SizedBox(height: 32),
//
//               // Email Field
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: _emailFocusNode.hasFocus
//                         ? const Color(0xFF00FF81)
//                         : const Color(0xFF03624C),
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextField(
//                   focusNode: _emailFocusNode,
//                   controller: emailController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     hintStyle: const TextStyle(color: Color(0xFFAACBC4)),
//                     prefixIcon: Icon(
//                       Icons.email_outlined,
//                       color: _emailFocusNode.hasFocus
//                           ? const Color(0xFF00FF81)
//                           : const Color(0xFFAACBC4),
//                     ),
//                     border: InputBorder.none,
//                     contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Password Field
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: _passwordFocusNode.hasFocus
//                         ? const Color(0xFF00FF81)
//                         : const Color(0xFF03624C),
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextField(
//                   focusNode: _passwordFocusNode,
//                   controller: passwordController,
//                   obscureText: _obscureText,
//                   obscuringCharacter: '*',
//                   style: const TextStyle(color: Colors.white),
//                   onChanged: (value) {
//                     setState(() {
//                       _password = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     hintStyle: const TextStyle(color: Color(0xFFAACBC4)),
//                     prefixIcon: Icon(
//                       Icons.lock_outline_rounded,
//                       color: _passwordFocusNode.hasFocus
//                           ? const Color(0xFF00FF81)
//                           : Colors.grey,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                         color: _passwordFocusNode.hasFocus
//                             ? const Color(0xFF00FF81)
//                             : Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureText = !_obscureText;
//                         });
//                       },
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 3,
//                       decoration: BoxDecoration(
//                         color: ValidationService.hasEightChars(_password)
//                             ? const Color(0xFF00FF81)
//                             : Colors.grey,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       height: 3,
//                       decoration: BoxDecoration(
//                         color: ValidationService.hasOneDigit(_password)
//                             ? const Color(0xFF00FF81)
//                             : Colors.grey,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       height: 3,
//                       decoration: BoxDecoration(
//                         color: ValidationService.hasOneLetter(_password)
//                             ? const Color(0xFF00FF81)
//                             : Colors.grey,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               _validationItem(
//                   'Has at least 8 characters?',
//                   ValidationService.hasEightChars(_password)),
//               const SizedBox(height: 8),
//               _validationItem(
//                   'Has one digit?', ValidationService.hasOneDigit(_password)),
//               const SizedBox(height: 8),
//               _validationItem(
//                   'Has one letter?', ValidationService.hasOneLetter(_password)),
//               const SizedBox(height: 24),
//
//               ElevatedButton(
//                 onPressed: () {
//                   final email = emailController.text.trim();
//                   final password = passwordController.text.trim();
//
//                   if (!ValidationService.isValidEmail(email)) {
//                     _showToast(
//                       message: 'Invalid email address. Please enter a valid email.',
//                       backgroundColor: Colors.red,
//                       textColor: Colors.white,
//                     );
//                     return;
//                   }
//
//                   if (!ValidationService.hasEightChars(password) ||
//                       !ValidationService.hasOneDigit(password) ||
//                       !ValidationService.hasOneLetter(password)) {
//                     _showToast(
//                       message: 'Password must have at least 8 characters, one digit, and one letter.',
//                       backgroundColor: Colors.red,
//                       textColor: Colors.white,
//                     );
//                     return;
//                   }
//
//                   _authService.register(
//                     context: context,
//                     email: email,
//                     password: password,
//                     hasEightChars: ValidationService.hasEightChars(password),
//                     hasOneDigit: ValidationService.hasOneDigit(password),
//                     hasOneLetter: ValidationService.hasOneLetter(password),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF00FF81),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Register',
//                   style: TextStyle(
//                     color: Color(0xFF021B1A),
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Already registered? ",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       'Login Now',
//                       style: TextStyle(
//                         color: Color(0xFF00FF81),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _validationItem(String text, bool isValid) {
//     return Row(
//       children: [
//         Icon(
//           isValid ? Icons.check_circle : Icons.check_circle_outline,
//           color: isValid ? const Color(0xFF00FF81) : Colors.white54,
//           size: 20,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           text,
//           style: TextStyle(
//             color: isValid ? const Color(0xFF00FF81) : Colors.white54,
//           ),
//         ),
//       ],
//     );
//   }
// }