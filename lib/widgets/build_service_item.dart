import 'package:flutter/material.dart';

Widget buildServiceItem({
  required String iconPath,
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed, // Use the passed callback
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(8.0),
      backgroundColor: const Color(0xFF0B453A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      minimumSize: const Size(185, 80),
      elevation: 0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        Image.asset(
          iconPath,
          height: 70,
          width: 85,
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
