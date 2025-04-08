/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import '../model/news_data.dart';
import '../pages/news_option_screen.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final int index;

  const NewsCard({
    super.key,
    required this.news,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth < 600 ? 110.0 : 130.0;
    final imageWidth = screenWidth < 600 ? 110.0 : 130.0;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsOptionScreen(news: news),
          ),
        );
        if (result == true) {
          // This will be handled in the parent ListView
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF0B453A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: imageWidth,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  color: Color(0xFF06302B),
                ),
                child: Stack(
                  children: [
                    if (news.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                        child: Image.network(
                          news.imageUrl,
                          fit: BoxFit.cover,
                          width: imageWidth,
                          height: cardHeight,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder(imageWidth, cardHeight);
                          },
                        ),
                      )
                    else
                      _buildPlaceholder(imageWidth, cardHeight),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFF06302B),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth < 600 ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        news.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth < 600 ? 16 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (screenWidth >= 600) ...[
                        const SizedBox(height: 8),
                        Text(
                          news.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFF06302B),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: const Color(0xFF00DF81).withOpacity(0.5),
          size: 32,
        ),
      ),
    );
  }
}