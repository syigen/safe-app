/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */
import 'dart:io';
import 'package:flutter/material.dart';
import '../components/casualties_section.dart';
import '../components/date_field.dart';
import '../components/distance_buttons.dart';
import '../components/elephant_count_field.dart';
import '../components/image_section.dart';
import '../components/location_field.dart';
import '../components/send_button.dart';
import '../components/special_notes_section.dart';
import '../components/time_field.dart';
import '../model/alert_data.dart';
import '../styles/constants.dart';
import '../utils/size_config.dart';
import 'package:safe_app/components/time_buttons.dart';

class ExpandedView extends StatelessWidget {
  final TextEditingController locationController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController elephantCountController;
  final TextEditingController specialNotesController;
  final String specialNote;
  final String selectedCasualtyOption;
  final String selectedTimeButtonValue;
  final File? selectedImage;
  final Function onPickImage;
  final Function onSendButtonPressed;
  final Function onDistanceRangeChanged;
  final Function onTimeButtonChanged;
  final Function onCasualtyOptionChanged;
  final DistanceRange selectedDistanceRange;
  final Widget header;

  ExpandedView({
    required this.locationController,
    required this.dateController,
    required this.timeController,
    required this.elephantCountController,
    required this.specialNotesController,
    required this.specialNote,
    required this.selectedCasualtyOption,
    required this.selectedTimeButtonValue,
    required this.selectedImage,
    required this.onPickImage,
    required this.onSendButtonPressed,
    required this.onDistanceRangeChanged,
    required this.onTimeButtonChanged,
    required this.onCasualtyOptionChanged,
    required this.selectedDistanceRange,
    required this.header, // Accept the header widget
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
          header, // Use the header widget passed from BottomPanel
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF032221),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  LocationField(
                    locationController: locationController,
                    primaryColor: primaryColor,
                  ),
                  Divider(color: Colors.white, thickness: 1),
                  DateField(
                    dateController: dateController,
                    primaryColor: primaryColor,
                  ),
                  Divider(color: Colors.white, thickness: 1),
                  TimeField(
                    timeController: timeController,
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
          DistanceButtons(
            selectedDistanceRange: selectedDistanceRange,
            onDistanceSelected: (value) => onDistanceRangeChanged(value),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
          buildTimeButtons(
            selectedTimeButtonValue: selectedTimeButtonValue,
            onTimeButtonSelected: (value) => onTimeButtonChanged(value),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
          ElephantCountField(
            elephantCountController: elephantCountController,
            primaryColor: primaryColor,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
          CasualtiesSection(
            selectedCasualtyOption: selectedCasualtyOption,
            onCasualtyOptionChanged: (value) => onCasualtyOptionChanged(value),
            primaryColor: primaryColor,
          ),
          SpecialNotesSection(
            specialNotesController: specialNotesController,
            onChanged: (value) => onDistanceRangeChanged(value),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
          ImageSection(
            onPressed: () => onPickImage(),
            selectedImage: selectedImage,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 2),
          SendButton(onPressed: () => onSendButtonPressed()),
          SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
        ],
      ),
    );
  }
}

