/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';

class SpecialNotesSection extends StatelessWidget {
  final TextEditingController specialNotesController;
  final ValueChanged<String> onChanged;

  const SpecialNotesSection({
    super.key,
    required this.specialNotesController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Special notes (Optional)', style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: specialNotesController,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Type here...',
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF00FF9D)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
        ),
      ],
    );
  }
}