/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:safe_app/model/comment_data.dart';

class CommentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get currently logged in user
  User? get currentUser => _supabase.auth.currentUser;

  // Add a new comment to the news item and increment comment count
  Future<Comment> addComment({
    required int newsId,
    required String content
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('comments')
          .insert({
        'news_id': newsId,
        'user_id': user.id,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      await _incrementCommentCount(newsId);

      return Comment.fromJson(response);
    } catch (e) {
      debugPrint('Error adding comment: $e');
      rethrow;
    }
  }

  // Increment the comment count for a news item
  Future<void> _incrementCommentCount(int newsId) async {
    try {
      final newsResponse = await _supabase
          .from('news')
          .select('comment_count')
          .eq('id', newsId)
          .single();

      final currentCount = newsResponse['comment_count'] as int? ?? 0;
      final newCount = currentCount + 1;

      await _supabase
          .from('news')
          .update({'comment_count': newCount})
          .eq('id', newsId);
    } catch (e) {
      debugPrint('Error incrementing comment count: $e');
    }
  }

  // Get all comments for a specific news item
  Future<List<Comment>> getCommentsByNewsId(int newsId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, profiles:user_id(*)')
          .eq('news_id', newsId)
          .order('created_at');

      return (response as List)
          .map((comment) => Comment.fromJson(comment))
          .toList();
    } catch (e) {
      debugPrint('Error fetching comments: $e');
      rethrow;
    }
  }

  // Delete a comment (only if user is the author) and decrement comment count
  Future<void> deleteComment(int commentId) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final commentResponse = await _supabase
          .from('comments')
          .select('news_id')
          .eq('id', commentId)
          .single();

      final newsId = commentResponse['news_id'] as int;

      await _supabase
          .from('comments')
          .delete()
          .match({'id': commentId, 'user_id': user.id});

      await _decrementCommentCount(newsId);
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      rethrow;
    }
  }

  // Decrement the comment count for a news item
  Future<void> _decrementCommentCount(int newsId) async {
    try {
      final newsResponse = await _supabase
          .from('news')
          .select('comment_count')
          .eq('id', newsId)
          .single();

      final currentCount = newsResponse['comment_count'] as int? ?? 0;
      final newCount = currentCount > 0 ? currentCount - 1 : 0;

      await _supabase
          .from('news')
          .update({'comment_count': newCount})
          .eq('id', newsId);
    } catch (e) {
      debugPrint('Error decrementing comment count: $e');
    }
  }

  // Update a comment (only if user is the author)
  Future<Comment> updateComment({
    required int commentId,
    required String content
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('comments')
          .update({'content': content})
          .match({'id': commentId, 'user_id': user.id})
          .select()
          .single();

      return Comment.fromJson(response);
    } catch (e) {
      debugPrint('Error updating comment: $e');
      rethrow;
    }
  }
}