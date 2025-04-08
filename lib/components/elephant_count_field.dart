/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class ElephantCountField extends StatelessWidget {
  final TextEditingController elephantCountController;
  final Color primaryColor;

  const ElephantCountField({super.key,
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
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
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