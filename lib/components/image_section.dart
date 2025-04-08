/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/image_picker_button.dart';

class ImageSection extends StatelessWidget {
  final Function() onPressed;
  final File? selectedImage;

  const ImageSection({
    super.key,
    required this.onPressed,
    this.selectedImage,
  });

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