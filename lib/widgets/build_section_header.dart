import 'package:flutter/material.dart';

Widget buildSectionHeader(String title, {required VoidCallback onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextButton(
        onPressed: onTap,
        child: const Text(
          'See all',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}