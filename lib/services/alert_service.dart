import 'package:flutter/material.dart';
import 'package:safe_app/model/alert_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';

class AlertService {
  Future<void> saveAlertData(AlertData alertData) async {
    try {
      String? imageUrl;

      if (alertData.image != null) {
        final file = alertData.image!;
        final path = 'public/${file.path.split('/').last}';
        try {
          await supabase.storage.from('alerts').upload(path, file);
          imageUrl = supabase.storage.from('alerts').getPublicUrl(path);
        } catch (e) {
          _showToast(
            message: 'Image upload failed: $e',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }
      }

      final response = await supabase.from('alert').insert({
        'location': alertData.location,
        'date': alertData.date,
        'elephant_count': alertData.elephantCount,
        'casualty_option': alertData.casualtyOption,
        'special_note': alertData.specialNote,
        'image_url': imageUrl,
        'time_button_value': alertData.timeButtonValue,
      }).select();

      if (response != null && response.isNotEmpty) {
        _showToast(
          message: 'Alert data saved successfully!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        _showToast(
          message: 'Failed to save data: Response is empty.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      _showToast(
        message: 'Error saving alert data: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showToast({
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
