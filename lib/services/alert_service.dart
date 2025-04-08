/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/alert_data.dart';

class AlertService {
  // Load environment variables
  final String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  // Constructor
  AlertService();

  // Get alerts from Supabase
  Future<List<AlertData>> getAlerts() async {
    final Uri url = Uri.parse('$supabaseUrl/rest/v1/alerts?select=*');

    try {
      final response = await http.get(
        url,
        headers: {
          'apikey': supabaseAnonKey,
          'Authorization': 'Bearer $supabaseAnonKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<AlertData> alerts = data.map((alertJson) => AlertData(
          location: alertJson['location'],
          date: alertJson['date'],
          time: alertJson['time'],
          elephantCount: alertJson['elephant_count'],
          casualtyOption: alertJson['casualty_option'] ?? '',
          specialNote: alertJson['special_note'] ?? '',
          timeButtonValue: alertJson['time_button_value'],
          distanceRange: DistanceRange.values.firstWhere(
                  (e) => e.name == alertJson['distance_range']),
          image: alertJson['image_url'] != null && alertJson['image_url'].isNotEmpty
              ? File(alertJson['image_url'])
              : null,
        )).toList();
        return alerts;
      } else {
        throw Exception('Failed to load alerts: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching alerts: $e');
    }
  }

  // Post an alert to Supabase
  Future<void> postAlert(AlertData alertData) async {
    final Uri url = Uri.parse('$supabaseUrl/rest/v1/alerts');
    try {
      Map<String, dynamic> body = {
        'location': alertData.location,
        'date': alertData.date,
        'time': alertData.time,
        'elephant_count': alertData.elephantCount,
        'casualty_option': alertData.casualtyOption,
        'special_note': alertData.specialNote,
        'time_button_value': alertData.timeButtonValue,
        'distance_range': alertData.distanceRange.name,
      };

      // Upload image if available
      if (alertData.image != null) {
        String imageUrl = await _uploadImage(alertData.image!);
        body['image_url'] = imageUrl;
      }

      final response = await http.post(
        url,
        headers: {
          'apikey': supabaseAnonKey,
          'Authorization': 'Bearer $supabaseAnonKey',
          'Content-Type': 'application/json',
          'Prefer': 'return=minimal',
        },
        body: json.encode(body),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to post alert: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error posting alert: $e');
    }
  }

  // Helper function to upload an image and return the image URL
  Future<String> _uploadImage(File image) async {
    final String fileName = image.uri.pathSegments.last;
    final String storagePath = 'elephant_alerts/$fileName';

    final Uri uploadUrl = Uri.parse('$supabaseUrl/storage/v1/object/$storagePath');

    try {
      var request = http.MultipartRequest('POST', uploadUrl);
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      request.headers.addAll({
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
      });

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String imageUrl = '$supabaseUrl/storage/v1/object/public/$storagePath';
        return imageUrl;
      } else {
        throw Exception('Failed to upload image: $responseBody');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}