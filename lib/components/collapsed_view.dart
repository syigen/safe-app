/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import 'package:safe_app/components/time_buttons.dart';
import '../model/alert_data.dart';
import '../utils/size_config.dart';
import '../components/distance_buttons.dart';
import '../components/send_button.dart';
import '../components/elephant_count_selector.dart';

class CollapsedView extends StatelessWidget {
  final TextEditingController locationController;
  final String selectedLocationText;
  final int selectedElephantCount;
  final Function(int) onElephantCountChanged;
  final DistanceRange selectedDistanceRange;
  final Function(DistanceRange) onDistanceSelected;
  final String selectedTimeButtonValue;
  final Function(String) onTimeButtonSelected;
  final VoidCallback onSendPressed;

  const CollapsedView({
    super.key,
    required this.locationController,
    required this.selectedLocationText,
    required this.selectedElephantCount,
    required this.onElephantCountChanged,
    required this.selectedDistanceRange,
    required this.onDistanceSelected,
    required this.selectedTimeButtonValue,
    required this.onTimeButtonSelected,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 4,
        vertical: SizeConfig.blockSizeVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 20,
              height: SizeConfig.blockSizeVertical * 0.5,
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Sighting marker  ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                  ),
                ),
                Text(
                  selectedLocationText,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * 0.3),
          Text(
            'No. of elephants',
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 3.5,
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.3),
          buildElephantCountSelector(
            selectedElephantCount: selectedElephantCount,
            onElephantCountSelected: onElephantCountChanged,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.3),
          DistanceButtons(
            selectedDistanceRange: selectedDistanceRange,
            onDistanceSelected: onDistanceSelected,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.3),
          buildTimeButtons(
            selectedTimeButtonValue: selectedTimeButtonValue,
            onTimeButtonSelected: onTimeButtonSelected,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1),
          SendButton(onPressed: onSendPressed),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
        ],
      ),
    );
  }
}