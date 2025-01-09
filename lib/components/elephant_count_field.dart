import 'package:flutter/material.dart';

class ElephantCountField extends StatelessWidget {
  final TextEditingController elephantCountController;
  final Color primaryColor;

  ElephantCountField({
    required this.elephantCountController,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('No. of elephants', style: TextStyle(color: Colors.white, fontSize: 16)),
        TextField(
          controller: elephantCountController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            suffixIcon: Icon(Icons.edit, color: primaryColor),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
