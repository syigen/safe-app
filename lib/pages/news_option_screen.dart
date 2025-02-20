/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_app/pages/update_news_form.dart';
import '../model/news.dart';
import '../services/news_service.dart';
import '../widgets/CustomScroll.dart';
import 'admin_view_news_list.dart';


class NewsOptionScreen extends StatelessWidget {
  final News news;
  final NewsService _newsService = NewsService();

  NewsOptionScreen({Key? key, required this.news}) : super(key: key);

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
      backgroundColor: const Color(0xFF001A13),
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
                        margin: const EdgeInsets.all(8.0), // Add margin around the image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16), // Add border radius
                      // Ensure the image fits the rounded corners
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16), // Ensure the corners are rounded
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
                    // Back button with semi-transparent background
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF06302B).withOpacity(0.7),
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
                      // Title with proper styling
                      Text(
                        news.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description with proper styling
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF032221),
                          borderRadius: BorderRadius.circular(12),
                          // border: Border.all(color: const Color(0xFF00DF81).withOpacity(0.3)),
                        ),
                        child: Text(
                          news.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
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
      // Bottom navigation bar with UPDATE and DELETE buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF021B1A),
        ),

        //UpdateNewsScreen(news: news)
          child: Container(
            margin: const EdgeInsets.only(bottom: 15, left: 16, right: 16), // Added more bottom margin
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
                        Navigator.pop(context, true); // Return true to trigger refresh
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
                      backgroundColor: const Color(0xFF00483B),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16), // Reduced vertical padding
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
                const SizedBox(width: 12), // Reduced spacing between buttons
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
                      backgroundColor: const Color(0xFF00483B),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16), // Reduced vertical padding
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