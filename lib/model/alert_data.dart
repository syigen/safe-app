/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'dart:io';

enum DistanceRange { m100, m200, m500, m1000 }

class AlertData {
  final String location;
  final String date;
  final String time;
  final int elephantCount;
  final String casualtyOption;
  final String specialNote;
  final File? image;
  final String timeButtonValue;
  final DistanceRange distanceRange;

  AlertData({
    required this.location,
    required this.date,
    required this.time,
    required this.elephantCount,
    required this.casualtyOption,
    required this.specialNote,
    this.image,
    required this.timeButtonValue,
    required this.distanceRange,

  });

  @override
  String toString() {
    return 'Location: $location\n'
        'Date: $date\n'
        'Time: $time\n'
        'Elephant Count: $elephantCount\n'
        'Casualty: $casualtyOption\n'
        'Special Notes: $specialNote\n'
        'Image: ${image != null ? 'Image Selected at ${image!.path}' : 'No Image'}\n'
        'Time Button Value: $timeButtonValue\n'
        'Distance Range: ${distanceRange.name}';
  }
}
