/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> uploadImage(File imageFile) async {
    try {
      final extension = imageFile.path.split('.').last.toLowerCase();
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      await supabase.storage.from('news_images').upload(imageName, imageFile);
      return supabase.storage.from('news_images').getPublicUrl(imageName);
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<bool> addNews(String title, String description, File? imageFile) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      }

      await supabase.from('news').insert({
        'title': title,
        'description': description,
        'image_url': imageUrl ?? '',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error adding news: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllNews() async {
    try {
      final response = await supabase.from('news').select().order('created_at', ascending: false);
      return response;
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getNewsById(int id) async {
    try {
      final response = await supabase.from('news').select().eq('id', id).single();
      return response;
    } catch (e) {
      print('Error fetching news by ID: $e');
      return null;
    }
  }

  Future<bool> updateNews(int id, String title, String description, File? imageFile) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile);
      }

      await supabase.from('news').update({
        'title': title,
        'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
      }).eq('id', id);

      return true;
    } catch (e) {
      print('Error updating news: $e');
      return false;
    }
  }

  Future<bool> deleteNews(int id) async {
    try {
      await supabase.from('news').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting news: $e');
      return false;
    }
  }
}



