import 'package:flutter/material.dart';

class ImagePickerButton extends StatelessWidget {
  final VoidCallback onPressed;

  ImagePickerButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFF00FF9D)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF00FF9D)),
            SizedBox(width: 8),
            Text('Add images', style: TextStyle(color: Color(0xFF00FF9D))),
          ],
        ),
      ),
    );
  }
}
