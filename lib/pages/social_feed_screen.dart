import 'dart:ffi';

import 'package:flutter/material.dart';
import '../model/news_data.dart';

class SocialFeedScreen extends StatefulWidget {
  final News news;

  const SocialFeedScreen({Key? key, required this.news}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  bool _showCommentBox = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleCommentBox() {
    setState(() {
      _showCommentBox = !_showCommentBox;
    });
  }

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news.title),
        backgroundColor: const Color(0xFF021B1A),
      ),
      backgroundColor: const Color(0xFF021B1A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.news.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.news.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      ),
                    )
                  else
                    _buildPlaceholder(),
                  const SizedBox(height: 16),
                  Text(
                    widget.news.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.news.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Action buttons
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF021B1A),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.thumb_up_outlined,
                        label: 'Like',
                        onPressed: () {},
                        cornerRadius: <double>[10, 0, 10, 0],
                      ),
                    ),
                    const VerticalDivider(
                      width: 5,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: 'Comment',
                        onPressed: _toggleCommentBox,
                        cornerRadius: <double>[0, 0, 0, 0],
                      ),
                    ),
                    const VerticalDivider(
                      width: 5,
                      thickness: 1,
                      color: Color(0xFF1A3A3A),
                    ),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onPressed: () {},
                        cornerRadius: <double>[0, 10, 0, 10],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Comment Box
            if (_showCommentBox) _buildCommentBox(),

            // Comments List
            if (_comments.isNotEmpty) _buildCommentsList(),

            // Social Feed
            Container(
              color: Colors.transparent,
              child: const SizedBox(height: 50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0B453A),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _submitComment,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF00CC66),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Comments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B453A),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF00CC66),
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'User',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _comments[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.white38,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required List<double> cornerRadius,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(cornerRadius[0]),
            topRight: Radius.circular(cornerRadius[1]),
            bottomLeft: Radius.circular(cornerRadius[2]),
            bottomRight: Radius.circular(cornerRadius[3]),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        backgroundColor: const Color(0xFF0B453A),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF00CC66),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00CC66),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// class TrianglePainter extends CustomPainter {
//   final Color color;
//
//   TrianglePainter(this.color);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//
//     final path = Path()
//       ..moveTo(0, size.height / 2)
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width, size.height)
//       ..close();
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

