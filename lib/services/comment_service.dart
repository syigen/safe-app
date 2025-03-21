/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:safe_app/model/comment_data.dart';

class CommentService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get currently logged in user
  User? get currentUser => _supabase.auth.currentUser;

  /// Add a new comment to the news item
  Future<Comment> addComment({
    required int newsId,
    required String content
  }) async {
    try {
      // Check if user is authenticated
      final user = currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Insert the comment
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

      return Comment.fromJson(response);
    } catch (e) {
      debugPrint('Error adding comment: $e');
      rethrow;
    }
  }

  /// Get all comments for a specific news item
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

  /// Delete a comment (only if user is the author)
  Future<void> deleteComment(int commentId) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('comments')
          .delete()
          .match({'id': commentId, 'user_id': user.id});
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      rethrow;
    }
  }

  /// Update a comment (only if user is the author)
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