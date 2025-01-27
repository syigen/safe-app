/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class DateTimeFields extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Color primaryColor;

  DateTimeFields({
    required this.dateController,
    required this.timeController,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date & time', style: TextStyle(color: Colors.white, fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: dateController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  suffixIcon: Icon(Icons.edit, color: primaryColor),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: timeController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  suffixIcon: Icon(Icons.edit, color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
