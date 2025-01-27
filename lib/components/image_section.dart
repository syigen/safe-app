/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/image_picker_button.dart';

class ImageSection extends StatelessWidget {
  final Function() onPressed;
  final File? selectedImage;

  const ImageSection({
    Key? key,
    required this.onPressed,
    this.selectedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagePickerButton(onPressed: onPressed),

      ],
    );
  }
}
