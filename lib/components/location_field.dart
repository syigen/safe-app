/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final TextEditingController locationController;
  final Color primaryColor;

  LocationField({
    required this.locationController,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Font size responsive to screen width
    double labelFontSize = screenWidth * 0.045; // 4.5% of screen width
    double inputFontSize = screenWidth * 0.04;  // 4% of screen width
    double paddingHorizontal = screenWidth * 0.05; // Horizontal padding proportional to screen width

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal), // Add horizontal padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLocationLabel(labelFontSize),
          Expanded(
            child: _buildLocationInput(inputFontSize),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationLabel(double fontSize) {
    return Text(
      'Location: ',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLocationInput(double fontSize) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextField(
        controller: locationController,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        enabled: false,
      ),
    );
  }
}
