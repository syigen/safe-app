import 'package:flutter/material.dart';

import '../styles/constants.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onPressed;

  SendButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Ensure primaryColor is defined in the relevant scope
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Send Alert',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
