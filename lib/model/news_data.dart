/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

class News {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String? authorId;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    this.authorId,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      authorId: json['author_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'author_id': authorId,
    };
  }
}