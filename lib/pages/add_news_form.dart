import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewsForm extends StatefulWidget {
  const AddNewsForm({super.key});

  @override
  State<AddNewsForm> createState() => _AddNewsViewState();
}

class _AddNewsViewState extends State<AddNewsForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

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
        final image = await picker.pickImage(
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

  void _handleAddNews() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter content'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Handle news creation with the collected data
    final news = {
      'title': _titleController.text,
      'content': _contentController.text,
      'image': _selectedImage,
    };

    // Close the form
    Navigator.of(context).pop(news);
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonWidth = screenWidth * 0.5;

    return Scaffold(
      backgroundColor: const Color(0xFF021B1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                maxLines: 4,
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF032221),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00FF9D),
                      width: 1,
                      style: BorderStyle.none,
                    ),
                  ),
                  child: DottedBorder(
                    color: const Color(0xFF00FF9D),
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(16),
                    padding: EdgeInsets.zero,
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
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedImage != null
                                        ? 'Change image'
                                        : 'Add images',
                                    style: TextStyle(
                                      color: const Color(0xFF00FF9D),
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
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: _handleAddNews,
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
      ),
    );
  }
}
