import 'package:flutter/material.dart';
import '../model/news.dart';

class NewsCard extends StatelessWidget {
  final int index;
  final News news;

  const NewsCard({
    super.key,
    required this.index,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // More aggressively reduce card width
    double cardWidth = screenWidth * 0.85;
    double cardHeight = screenWidth * 0.16;
    double imageSize = screenWidth * 0.22;
    double fontSize = screenWidth * 0.035;
    double indexBoxWidth = screenWidth * 0.08;
    double spacing = screenWidth * 0.012;

    return Center(
      child: Container(
        height: cardHeight,
        width: cardWidth,
        margin: EdgeInsets.only(bottom: spacing * 4),
        decoration: BoxDecoration(
          color: const Color(0xFF03624C),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FF94).withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(4, 4), 
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIndexWithHighlight(indexBoxWidth, fontSize),
            SizedBox(width: spacing),
            _buildImage(imageSize),
            SizedBox(width: spacing * 1.5),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: spacing * 2),
                child: _buildTitle(fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexWithHighlight(double width, double fontSize) {
    return SizedBox(
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: width * 0.8,
              width: 2,
              margin: EdgeInsets.only(right: width * 0.1),
              color: const Color(0xFF00DF81),
            ),
          ),
          Center(
            child: Text(
              index.toString(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.1),
      child: news.image != null
          ? Image.file(
        news.image!,
        width: size,
        height: size * 0.65,
        fit: BoxFit.cover,
      )
          : Container(
        width: size,
        height: size * 0.65,
        decoration: BoxDecoration(
          color: const Color(0xFF021B1A),
          borderRadius: BorderRadius.circular(size * 0.1),
        ),
        child: Icon(
          Icons.image,
          color: const Color(0xFF00DF81),
          size: size * 0.3,
        ),
      ),
    );
  }

  Widget _buildTitle(double fontSize) {
    return Text(
      news.title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}


