/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../model/news_data.dart';
import '../services/news_service.dart';
import 'admin_view_news_list.dart';

class UpdateNewsForm extends StatefulWidget {
  final News news;

  const UpdateNewsForm({super.key, required this.news});

  @override
  UpdateNewsScreenState createState() => UpdateNewsScreenState();
}

class UpdateNewsScreenState extends State<UpdateNewsForm> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _newsService = NewsService();
  File? _imageFile;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.news.title;
    _contentController.text = widget.news.description;
  }

  Future<void> _pickImage() async {
    final pickedOption = await showDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF032221),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Select Image Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF00FF9D)),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF00FF9D)),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption != null) {
      try {
        final image = await _imagePicker.pickImage(
          source: pickedOption,
          imageQuality: 80,
        );
        if (image?.path != null) {
          setState(() {
            _imageFile = File(image!.path);
          });
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error picking image: ${e.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
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

  Future<void> _updateNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      _showToast(
        message: 'Please fill in all fields',
        backgroundColor:  Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final success = await _newsService.updateNews(
      widget.news.id,
      _titleController.text,
      _contentController.text,
      _imageFile,
    );

    if (success) {
      _showToast(
        message: 'News Updated successfully!',
        backgroundColor: const Color(0xFF00DF81),
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsListView(),
        ),
      );
    } else {
      _showToast(
        message: 'Failed to update news',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    final horizontalPadding = screenSize.width * 0.05;
    final verticalPadding = screenSize.height * 0.02;

    final imageHeight = screenSize.height * 0.25;

    return Scaffold(
      backgroundColor: const Color(0xFF001A13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('UPDATE NEWS'),
        toolbarHeight: screenSize.height * 0.08,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview & Edit Icon
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _imageFile != null
                          ? Image.file(
                        _imageFile!,
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        widget.news.imageUrl,
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: imageHeight,
                            color: const Color(0xFF03624C),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.white60,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),

              // Title Input
              const Text(
                '• TITLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF03624C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: screenSize.height * 0.015,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),

              // Content Input
              const Text(
                '• CONTENT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              TextField(
                controller: _contentController,
                style: const TextStyle(color: Colors.white),
                maxLines: 8,
                minLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF03624C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: screenSize.height * 0.015,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),

              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: isLargeScreen ? 150 : screenSize.width * 0.4,
                  child: ElevatedButton(
                    onPressed: _updateNews,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03624C),
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLargeScreen ? 16 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom padding for keyboard
              SizedBox(height: screenSize.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}