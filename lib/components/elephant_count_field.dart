/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/size_config.dart';

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
        Text('No. of elephants', style: TextStyle(color: Colors.white, fontSize:SizeConfig.blockSizeHorizontal * 3.5)),
        TextField(
          controller: elephantCountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            // Ensure only digits are allowed
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: 'Enter number of elephants...',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00FF9D)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Icon(Icons.edit, color: primaryColor),
          ),
          style: TextStyle(color: Colors.white),
          maxLines: 1,
        ),
      ],
    );
  }
}
