import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Import AuthService
import '../services/auth_service.dart'; // Update this path if needed

class UpdateUserProfile extends StatefulWidget {
  final Function(String name, File? image)? onConfirm;
  final AuthService authService; // Add AuthService parameter

  const UpdateUserProfile({
    super.key,
    this.onConfirm,
    required this.authService, // Make it required
  });

  @override
  UpdateUserProfileState createState() => UpdateUserProfileState();
}

class UpdateUserProfileState extends State<UpdateUserProfile> {
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load current profile data
  }

  Future<void> _loadUserProfile() async {
    try {
      final userProfile = await widget.authService.getUserProfile();
      if (userProfile != null) {
        setState(() {
          _nameController.text = userProfile['fullName'] ?? '';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }

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

  // Show toast message helper
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

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Dialog(
        backgroundColor: Colors.transparent,
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
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
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
                  onPressed: _isLoading
                      ? null
                      : () async {
                    if (_nameController.text.isEmpty) {
                      _showToast(
                        message: 'Name cannot be empty',
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      // Update profile using AuthService
                      await widget.authService.updateProfile(
                        newName: _nameController.text,
                        newAvatar: _imageFile,
                      );

                      // Call the original callback if provided
                      if (widget.onConfirm != null) {
                        widget.onConfirm!(_nameController.text, _imageFile);
                      }

                      // Refresh user data in shared preferences
                      await widget.authService.refreshUserData();

                      // Close the popup
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      _showToast(
                        message: 'Failed to update profile: $e',
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00DF81),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
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
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}