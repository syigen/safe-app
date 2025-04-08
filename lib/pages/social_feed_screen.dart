/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import '../model/news_data.dart';
import '../services/auth_service.dart';
import '../services/comment_service.dart';
import '../services/news_like_service.dart';
import '../model/comment_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final authService = AuthService(authClient: SupabaseAuthClient());
  return authService.getUserProfile();
});

// Provider for comments
final commentsProvider = FutureProvider.autoDispose.family<List<Comment>, int>((ref, newsId) async {
  final commentService = CommentService();
  return commentService.getCommentsByNewsId(newsId);
});

// Provider for like status
final hasUserLikedProvider = FutureProvider.autoDispose.family<bool, int>((ref, newsId) async {
  final newsLikeService = NewsLikeService();
  return newsLikeService.hasUserLiked(newsId);
});

// Provider for like count
final likeCountProvider = FutureProvider.autoDispose.family<int, int>((ref, newsId) async {
  final newsLikeService = NewsLikeService();
  return newsLikeService.getLikeCount(newsId);
});

class SocialFeedScreen extends ConsumerStatefulWidget {
  final News news;

  const SocialFeedScreen({Key? key, required this.news}) : super(key: key);

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen> {
  bool _showCommentBox = false;
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  final NewsLikeService _newsLikeService = NewsLikeService();
  bool _isPostingComment = false;
  bool _isLikeProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(hasUserLikedProvider(widget.news.id));
      ref.refresh(likeCountProvider(widget.news.id));
      ref.refresh(userProfileProvider);
    });
  }

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

  Future<void> _toggleLike() async {
    if (_isLikeProcessing) return;

    setState(() {
      _isLikeProcessing = true;
    });

    try {
      final isNowLiked = await _newsLikeService.toggleLike(widget.news.id);

      // Refresh providers to update UI
      ref.refresh(hasUserLikedProvider(widget.news.id));
      ref.refresh(likeCountProvider(widget.news.id));

      // Show feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isNowLiked ? 'Liked successfully' : 'Unliked successfully'),
            backgroundColor: const Color(0xFF00CC66),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process like: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLikeProcessing = false;
        });
      }
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _isPostingComment = true;
      });

      try {
        await _commentService.addComment(
          newsId: widget.news.id,
          content: _commentController.text.trim(),
        );

        // Clear the input and refresh comments
        _commentController.clear();
        ref.refresh(commentsProvider(widget.news.id));

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment posted successfully'),
              backgroundColor: Color(0xFF00CC66),
            ),
          );
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to post comment: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isPostingComment = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUserLikedAsync = ref.watch(hasUserLikedProvider(widget.news.id));
    final likeCountAsync = ref.watch(likeCountProvider(widget.news.id));

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
                  const SizedBox(height: 12),
                  // Like counter
                  likeCountAsync.when(
                    data: (count) => count > 0
                        ? Text(
                      '$count ${count == 1 ? 'like' : 'likes'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
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
                      child: hasUserLikedAsync.when(
                        data: (isLiked) => _buildActionButton(
                          icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          label: isLiked ? 'Liked' : 'Like',
                          onPressed: _toggleLike,
                          cornerRadius: <double>[10, 0, 10, 0],
                          isActive: isLiked,
                          isProcessing: _isLikeProcessing,
                        ),
                        loading: () => _buildActionButton(
                          icon: Icons.thumb_up_outlined,
                          label: 'Like',
                          onPressed: () {},
                          cornerRadius: <double>[10, 0, 10, 0],
                          isProcessing: true,
                        ),
                        error: (_, __) => _buildActionButton(
                          icon: Icons.thumb_up_outlined,
                          label: 'Like',
                          onPressed: _toggleLike,
                          cornerRadius: <double>[10, 0, 10, 0],
                        ),
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
            _buildCommentsList(),

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
              onPressed: _isPostingComment ? null : _submitComment,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF00CC66),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: _isPostingComment
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              )
                  : const Text(
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
    final commentsAsync = ref.watch(commentsProvider(widget.news.id));

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
          commentsAsync.when(
            data: (comments) {
              if (comments.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: Text(
                    'No comments yet. Be the first to comment!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  final profileData = comment.userProfile as Map<String, dynamic>?;
                  final String fullName = profileData?['full_name'] ?? 'User';
                  final String avatarUrl = profileData?['avatar_url'] ?? '';

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
                        Row(
                          children: [
                            avatarUrl.isNotEmpty
                                ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(avatarUrl),
                              onBackgroundImageError: (exception, stackTrace) {
                              },
                            )
                                : const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/user/default.png'),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          comment.content,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(
                  color: Color(0xFF00CC66),
                ),
              ),
            ),
            error: (error, stackTrace) => Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                'Error loading comments: ${error.toString()}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
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
    bool isActive = false,
    bool isProcessing = false,
  }) {
    final color = isActive ? const Color(0xFF00CC66) : const Color(0xFF00CC66).withOpacity(0.7);

    return TextButton(
      onPressed: isProcessing ? null : onPressed,
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
      child: isProcessing
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Color(0xFF00CC66),
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}