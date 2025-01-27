/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

import '../styles/constants.dart';

Widget buildElephantCountSelector({
  required int selectedElephantCount,
  required Function(int) onElephantCountSelected,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      double buttonSpacing = screenWidth * 0.05; // Adjust spacing between buttons (5% of screen width)
      final buttonSize = screenWidth * 0.10; // 12% of screen width for button size

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center, // Center the Row horizontally
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the buttons within the Row
            children: List.generate(5, (index) {
              final number = index == 4 ? '5+' : '${index + 1}';
              final isSelected = selectedElephantCount == (index == 4 ? 5 : index + 1);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: buttonSpacing / 2), // Half of the spacing on both sides
                child: GestureDetector(
                  onTap: () {
                    onElephantCountSelected(index == 4 ? 5 : index + 1);
                  },
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? primaryColor : Colors.transparent,
                      border: Border.all(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        number,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: screenWidth * 0.045, // Font size relative to screen width
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    },
  );
}
