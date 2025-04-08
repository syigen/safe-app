/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_app/pages/update_news_form.dart';
import '../model/news_data.dart';
import '../services/news_service.dart';
import '../widgets/CustomScroll.dart';
import 'admin_view_news_list.dart';

class NewsOptionScreen extends StatelessWidget {
  final News news;
  final NewsService _newsService = NewsService();

  NewsOptionScreen({super.key, required this.news});

  Future<void> _deleteNews(BuildContext context) async {
    final navigator = Navigator.of(context);
    try {
      final success = await _newsService.deleteNews(news.id);
      if (success) {
        _showToast(
          message: 'News Deleted successfully!',
          backgroundColor: const Color(0xFF00DF81),
          textColor: Colors.white,
        );
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => NewsListView()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showToast(
          message: 'Error: ${e.toString()}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF021B1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        title: const Text(
          'Delete News',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this news item?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Color(0xFF00DF81)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNews(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF06302B),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF03624C)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B1A),
      appBar:_buildAppBar(context) ,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    if (news.imageUrl.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            news.imageUrl,
                            width: double.infinity,
                            height: 230,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 230,
                                width: double.infinity,
                                color: const Color(0xFF03624C),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Color(0xFF00DF81),
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 230,
                        width: double.infinity,
                        color: const Color(0xFF03624C),
                        child: const Icon(
                          Icons.image,
                          color: Color(0xFF00DF81),
                          size: 50,
                        ),
                      ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF06302B).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(
                          color: Color(0xFFF1F7F6 ),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF032221),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          news.description,
                          style: const TextStyle(
                            color: Color(0xFFB4BDBD ),
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF021B1A),
        ),

        //UpdateNewsScreen(news: news)
          child: Container(
            margin: const EdgeInsets.only(bottom: 15, left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>UpdateNewsForm(news: news),
                        ),
                      );
                      if (result == true) {
                        Navigator.pop(context, true);
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B453A),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteConfirmation(context),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text(
                      'DELETE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B453A),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}