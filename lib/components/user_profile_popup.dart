import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePopup extends StatefulWidget {
  final Function(String name, File? image)? onConfirm;

  const ProfilePopup({super.key, this.onConfirm});

  @override
  ProfilePopupState createState() => ProfilePopupState();
}

class ProfilePopupState extends State<ProfilePopup> {
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2 * 1024 * 1024,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button from closing the dialog
      onWillPop: () async => false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Dialog(
          backgroundColor: Colors.transparent,
          // Prevent dismissing by clicking outside
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF032221),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF00DF81),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Removed the close button

                // Title text instead of close button
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                // Profile picture
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          image: _imageFile != null
                              ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                              : const DecorationImage(
                            image: AssetImage('assets/user/default.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1A2C2C),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'profile picture size should not exceed 2MB',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                // Name text field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your name here',
                      hintStyle: const TextStyle(color: Color(0xFF686868)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm button
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        widget.onConfirm?.call(_nameController.text, _imageFile);
                        Navigator.pop(context);
                      } else {
                        // Show an error message if name is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your name'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00DF81),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}