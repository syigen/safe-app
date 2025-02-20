import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../services/news_service.dart';
import 'admin_view_news_list.dart';

class AddNewsForm extends ConsumerStatefulWidget {
  @override
  _AddNewsScreenState createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends ConsumerState<AddNewsForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final _newsService = NewsService();
  File? _selectedImage;
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
            _selectedImage = File(image!.path);
          });
        }
      } catch (e) {
        if (context.mounted) {
          _showToast(
            message: 'Error picking image: ${e.toString()}',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  Future<void> _submitNews() async {
    if (_titleController.text.isEmpty) {
      _showToast(
        message: 'Please enter a title',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      _showToast(
        message: 'Please enter content',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final success = await _newsService.addNews(
      _titleController.text,
      _contentController.text,
      _selectedImage,
    );

    if (success) {
      _showToast(
        message: 'News Added successfully!',
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
        message: 'Failed to add news',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsListView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.5;

    return Scaffold(
      backgroundColor: const Color(0xFF021B1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF06302B),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF03624C),
              ),
              iconSize: 28,
            ),
          ),
        ),
        title: const Text(
          'ADD A NEWS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '• TITLE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF03624C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '• CONTENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white),
              maxLines: 10,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF03624C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '• IMAGES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF032221),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DottedBorder(
                  color: const Color(0xFF00FF9D),
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(16),
                  dashPattern: const [8, 8],
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Column(
                          children: [
                            if (_selectedImage != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: const Color(0xFF00FF9D),
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedImage != null
                                      ? 'Change image'
                                      : 'Add images',
                                  style: const TextStyle(
                                    color: Color(0xFF00FF9D),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: _submitNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03624C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}