/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
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
      double buttonSpacing = screenWidth * 0.05;
      final buttonSize = screenWidth * 0.10;

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final number = index == 4 ? '5+' : '${index + 1}';
              final isSelected = selectedElephantCount == (index == 4 ? 5 : index + 1);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: buttonSpacing / 2),
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
                          fontSize: screenWidth * 0.045,
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