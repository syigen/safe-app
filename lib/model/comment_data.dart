/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

class Comment {
  final int id;
  final int newsId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final Map<String, dynamic>? userProfile;

  Comment({
    required this.id,
    required this.newsId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.userProfile,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      newsId: json['news_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      userProfile: json['profiles'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'news_id': newsId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'profiles': userProfile,
    };
  }
}