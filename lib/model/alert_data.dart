import 'dart:io';

class AlertData {
  final String location;
  final String date;
  final int elephantCount;
  final String casualtyOption;
  final String specialNote;
  final File? image;
  final String timeButtonValue;

  AlertData({
    required this.location,
    required this.date,
    required this.elephantCount,
    required this.casualtyOption,
    required this.specialNote,
    this.image,
    required this.timeButtonValue,
  });

  @override
  String toString() {
    return 'Location: $location\n'
        'Date: $date\n'
        'Elephant Count: $elephantCount\n'
        'Casualty: $casualtyOption\n'
        'Special Notes: $specialNote\n'
        'Image: ${image != null ? 'Image Selected at ${image!.path}' : 'No Image'}\n'
        'Time Button Value: $timeButtonValue';
  }
}