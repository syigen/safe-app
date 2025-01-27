/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final TextEditingController dateController;
  final Color primaryColor;

  DateField({
    required this.dateController,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Font size responsive to screen width
    double labelFontSize = screenWidth * 0.045; // 4.5% of screen width for label font size
    double inputFontSize = screenWidth * 0.04;  // 4% of screen width for input font size
    double paddingHorizontal = screenWidth * 0.05; // Horizontal padding proportional to screen width

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal), // Add horizontal padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateLabel(labelFontSize),
          Expanded(
            child: _buildDateInput(inputFontSize),
          ),
        ],
      ),
    );
  }

  Widget _buildDateLabel(double fontSize) {
    return Text(
      'Date',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDateInput(double fontSize) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextField(
        controller: dateController,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        enabled: false, // Disable the input field
        textAlign: TextAlign.end, // Text inside the input aligned to the right
        decoration: InputDecoration(
          border: InputBorder.none, // Remove underline
        ),
      ),
    );
  }
}
