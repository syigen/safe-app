import 'dart:io';

import 'package:flutter/material.dart';
import 'package:safe_app/model/alert_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AlertService {
  Future<void> saveAlertData(AlertData alertData) async {
    try {
      String? imageUrl;

      if (alertData.image != null) {
        final file = alertData.image!;
        final path = 'public/${file.path
            .split('/')
            .last}';
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

      // Convert DistanceRange to a string
      final response = await supabase.from('alert').insert({
        'location': alertData.location,
        'date': alertData.date,
        'time': alertData.time,
        'elephant_count': alertData.elephantCount,
        'casualty_option': alertData.casualtyOption,
        'special_note': alertData.specialNote,
        'image_url': imageUrl,
        'time_button_value': alertData.timeButtonValue,
        'distance_range': alertData.distanceRange.name,
        // Convert enum to string
      }).select();

      if (response.isNotEmpty) {
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

  /*Future<List<AlertData>> getAllAlerts() async {
    try {
      final response = await supabase.from('alert').select().order('date', ascending: false);

      if (response.isNotEmpty) {

        // Map the response to a list of AlertData
        final alertList = response.map<AlertData>((data) {
          return AlertData(
            location: data['location'],
            date:data['date'],
            time: data['time'],
            elephantCount: data['elephant_count'],
            casualtyOption: data['casualty_option'],
            specialNote: data['special_note'],
            image: null,

            timeButtonValue: data['time_button_value'],
            distanceRange: DistanceRange.values.firstWhere(
                  (e) => e.name == data['distance_range'],
              orElse: () => DistanceRange.m100, // Default value if no match
            ),
          );
        }).toList();

        return alertList;
      } else {
        _showToast(
          message: 'No alerts found.',
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        return [];
      }
    } catch (e) {
      _showToast(
        message: 'Error fetching alerts: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return [];
    }


  }*/

  Future<List<AlertData>> getAllAlerts() async {
    try {
      final response = await supabase.from('alert').select().order(
          'date', ascending: false);

      if (response.isNotEmpty) {
        final alertList = await Future.wait(
            response.map<Future<AlertData>>((data) async {
              File? imageFile;

              // Check if the image path exists
              if (data['image'] != null && data['image'].isNotEmpty) {
                final path = data['image']; // Assuming this stores the file path

                // Fetch the public URL of the image from Supabase Storage
                final imageUrl = supabase.storage.from('alerts').getPublicUrl(
                    path);

                // Download the image as a File
                final response = await http.get(Uri.parse(imageUrl));
                if (response.statusCode == 200) {
                  // Get the local directory to save the image
                  final directory = await getApplicationDocumentsDirectory();
                  final imagePath = '${directory
                      .path}/$path'; // Save the file locally
                  imageFile = File(imagePath)
                    ..writeAsBytesSync(response.bodyBytes);
                }
              }

              // Return the AlertData with the image as a File
              return AlertData(
                location: data['location'],
                date: data['date'],
                time: data['time'],
                elephantCount: data['elephant_count'],
                casualtyOption: data['casualty_option'],
                specialNote: data['special_note'],
                image: imageFile,
                // Pass the downloaded image as a File
                timeButtonValue: data['time_button_value'],
                distanceRange: DistanceRange.values.firstWhere(
                      (e) => e.name == data['distance_range'],
                  orElse: () => DistanceRange.m100, // Default value if no match
                ),
                imageUrl: null,
              );
            }).toList());

        return alertList;
      } else {
        _showToast(
          message: 'No alerts found.',
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        return [];
      }
    } catch (e) {
      _showToast(
        message: 'Error fetching alerts: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return [];
    }
  }

}
