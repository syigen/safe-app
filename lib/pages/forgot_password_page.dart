// import 'package:flutter/material.dart';
// import 'package:safe_app/pages/verification_page.dart';
//
// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController _emailController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF021B1A),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF00FF7F),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 80),
//
//               const Icon(
//                 Icons.fingerprint,
//                 size: 64,
//                 color: Color(0xFF00FF7F),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Forgot Password ?',
//                 style: TextStyle(
//                   color: Color(0xFFf1F7F6),
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'No worries, we\'ll send you reset instructions',
//                 style: TextStyle(
//                   color: Color(0xFFAFB4B3),
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 60),
//
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFF00FF7F)),
//                 ),
//                 child: TextField(
//                   controller: _emailController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     hintStyle: const TextStyle(color: Color(0xFFAACBC4)),
//                     prefixIcon: Icon(
//                       Icons.mail_outline,
//                       color: Colors.grey[400],
//                       size: 24,
//                     ),
//                     border: InputBorder.none,
//                     isDense: true,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 16,
//                     ),
//                     alignLabelWithHint: true,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 22),
//
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const VerificationScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF00FF81),
//                   minimumSize: const Size(double.infinity, 45),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Reset password',
//                   style: TextStyle(
//                     fontSize: 19,
//                     // color: Color(0xFF002B2A),
//                     color: Color(0xFF021B1A)
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: TextButton.styleFrom(
//                   foregroundColor: const Color(0xFF00FF7F),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.arrow_back, size: 20, color: Colors.white,),
//                     SizedBox(width: 8),
//                     Text(
//                       'Back',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF00DF81)
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }