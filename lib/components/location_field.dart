/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final TextEditingController locationController;
  final Color primaryColor;

  const LocationField({
    super.key,
    required this.locationController,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double labelFontSize = screenWidth * 0.045;
    double inputFontSize = screenWidth * 0.04;
    double paddingHorizontal = screenWidth * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        enabled: false,
      ),
    );
  }
}