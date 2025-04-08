/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import '../widgets/distance_button.dart';
import '../model/alert_data.dart';

class DistanceButtons extends StatelessWidget {
  final DistanceRange selectedDistanceRange;
  final ValueChanged<DistanceRange> onDistanceSelected;

  const DistanceButtons({
    super.key,
    required this.selectedDistanceRange,
    required this.onDistanceSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonSpacing = screenWidth * 0.03;
    double fontSize = screenWidth * 0.04;
    double buttonHeight = screenHeight * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Range of Distance',
          style: TextStyle(color: Colors.white, fontSize: SizeConfig.blockSizeHorizontal * 3.5),
        ),
        SizedBox(height: screenHeight * 0.001),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DistanceButton(
                text: 'Here',
                isSelected: selectedDistanceRange == DistanceRange.m0,
                onPressed: () => onDistanceSelected(DistanceRange.m0),
                fontSize: fontSize,
                buttonHeight: buttonHeight,
              ),
              SizedBox(width: buttonSpacing),
              DistanceButton(
                text: '250m',
                isSelected: selectedDistanceRange == DistanceRange.m250,
                onPressed: () => onDistanceSelected(DistanceRange.m250),
                fontSize: fontSize,
                buttonHeight: buttonHeight,
              ),
              SizedBox(width: buttonSpacing),
              DistanceButton(
                text: '500m',
                isSelected: selectedDistanceRange == DistanceRange.m500,
                onPressed: () => onDistanceSelected(DistanceRange.m500),
                fontSize: fontSize,
                buttonHeight: buttonHeight,
              ),
              SizedBox(width: buttonSpacing),
              DistanceButton(
                text: '500 + ',
                isSelected: selectedDistanceRange == DistanceRange.m500Plus,
                onPressed: () => onDistanceSelected(DistanceRange.m500Plus),
                fontSize: fontSize,
                buttonHeight: buttonHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}