import 'package:flutter/material.dart';
import '../model/news_data.dart';
import '../pages/news_option_screen.dart'; // Import the news option screen

class NewsCard extends StatelessWidget {
  final News news;
  final int index;

  const NewsCard({
    Key? key,
    required this.news,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate dynamic height based on screen size
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
        // Handle refresh if needed
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
            // Add subtle shadow for depth
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
              // Image container with null handling
              Container(
                width: imageWidth,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  color: Color(0xFF06302B), // Background color for empty state
                ),
                child: Stack(
                  children: [
                    // Image with error handling
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
                    // Index number overlay
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