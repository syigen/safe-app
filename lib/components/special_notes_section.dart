import 'package:flutter/material.dart';

class SpecialNotesSection extends StatelessWidget {
  final TextEditingController specialNotesController;
  final ValueChanged<String> onChanged;

  const SpecialNotesSection({
    Key? key,
    required this.specialNotesController,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Special notes (Optional)', style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: specialNotesController,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Type here...',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),  // Customize color as needed
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: TextStyle(color: Colors.white),
          maxLines: 3,
        ),
      ],
    );
  }
}
