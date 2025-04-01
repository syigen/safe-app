/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

class NewsLike {
  final int id;
  final int newsId;
  final String userId;
  final DateTime createdAt;

  NewsLike({
    required this.id,
    required this.newsId,
    required this.userId,
    required this.createdAt,
  });

  factory NewsLike.fromJson(Map<String, dynamic> json) {
    return NewsLike(
      id: json['id'],
      newsId: json['news_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'news_id': newsId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}