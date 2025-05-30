/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/news_like_data.dart';

class NewsLikeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get currently logged in user
  User? get currentUser => _supabase.auth.currentUser;

  // Toggle like for a news item (like if not liked, unlike if already liked)
  Future<bool> toggleLike(int newsId) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final existingLike = await _getUserLike(newsId);

      if (existingLike != null) {
        await _deleteLike(existingLike.id);
        await _decrementLikeCount(newsId);
        return false;
      } else {
        await _addLike(newsId);
        await _incrementLikeCount(newsId);
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      rethrow;
    }
  }

  // Check if the current user has liked a specific news
  Future<bool> hasUserLiked(int newsId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return false;
      }

      final response = await _supabase
          .from('news_likes')
          .select()
          .eq('news_id', newsId)
          .eq('user_id', user.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('Error checking if user liked news: $e');
      return false;
    }
  }

  // Get the user's like for a specific news
  Future<NewsLike?> _getUserLike(int newsId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return null;
      }

      final response = await _supabase
          .from('news_likes')
          .select()
          .eq('news_id', newsId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return NewsLike.fromJson(response);
    } catch (e) {
      debugPrint('Error getting user like: $e');
      return null;
    }
  }

  // Add a like to a news item
  Future<NewsLike> _addLike(int newsId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('news_likes')
          .insert({
        'news_id': newsId,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      return NewsLike.fromJson(response);
    } catch (e) {
      debugPrint('Error adding like: $e');
      rethrow;
    }
  }

  // Delete a like
  Future<void> _deleteLike(int likeId) async {
    try {
      await _supabase
          .from('news_likes')
          .delete()
          .eq('id', likeId);
    } catch (e) {
      debugPrint('Error deleting like: $e');
      rethrow;
    }
  }

  // Increment the like count for a news item
  Future<void> _incrementLikeCount(int newsId) async {
    try {
      // Get the current like count
      final newsResponse = await _supabase
          .from('news')
          .select('like_count')
          .eq('id', newsId)
          .single();

      final currentCount = newsResponse['like_count'] as int? ?? 0;
      final newCount = currentCount + 1;

      await _supabase
          .from('news')
          .update({'like_count': newCount})
          .eq('id', newsId);
    } catch (e) {
      debugPrint('Error incrementing like count: $e');
    }
  }

  // Decrement the like count for a news item
  Future<void> _decrementLikeCount(int newsId) async {
    try {
      final newsResponse = await _supabase
          .from('news')
          .select('like_count')
          .eq('id', newsId)
          .single();

      final currentCount = newsResponse['like_count'] as int? ?? 0;
      final newCount = currentCount > 0 ? currentCount - 1 : 0;

      await _supabase
          .from('news')
          .update({'like_count': newCount})
          .eq('id', newsId);
    } catch (e) {
      debugPrint('Error decrementing like count: $e');
    }
  }

  // Get the total number of likes for a news item
  Future<int> getLikeCount(int newsId) async {
    try {
      final response = await _supabase
          .from('news')
          .select('like_count')
          .eq('id', newsId)
          .single();

      return response['like_count'] as int? ?? 0;
    } catch (e) {
      debugPrint('Error getting like count: $e');
      return 0;
    }
  }
}