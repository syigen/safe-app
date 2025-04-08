/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import '../widgets/time_button.dart';

Widget buildTimeButtons({
  required String selectedTimeButtonValue,
  required Function(String) onTimeButtonSelected,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      double buttonSpacing = screenWidth * 0.05;
      double fontSize = screenWidth * 0.04;
      double buttonHeight = screenHeight * 0.06;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time of Sight',
            style: TextStyle(color: Colors.white, fontSize: SizeConfig.blockSizeHorizontal * 3.5),
          ),
          SizedBox(height: screenHeight * 0.001),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeButton(
                  text: '30 min +',
                  isSelected: selectedTimeButtonValue == '30 min +',
                  onPressed: () => onTimeButtonSelected('30 min +'),
                  fontSize: fontSize,
                  buttonHeight: buttonHeight,
                ),
                SizedBox(width: buttonSpacing),
                TimeButton(
                  text: 'in 30 min',
                  isSelected: selectedTimeButtonValue == 'in 30 min',
                  onPressed: () => onTimeButtonSelected('in 30 min'),
                  fontSize: fontSize,
                  buttonHeight: buttonHeight,
                ),
                SizedBox(width: buttonSpacing),
                TimeButton(
                  text: 'Now',
                  isSelected: selectedTimeButtonValue == 'Now',
                  onPressed: () => onTimeButtonSelected('Now'),
                  fontSize: fontSize,
                  buttonHeight: buttonHeight,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}