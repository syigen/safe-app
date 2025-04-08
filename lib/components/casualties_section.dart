/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class CasualtiesSection extends StatelessWidget {
  final String selectedCasualtyOption;
  final ValueChanged<String?>? onCasualtyOptionChanged;
  final Color primaryColor;

  const CasualtiesSection({
    super.key,
    required this.selectedCasualtyOption,
    required this.onCasualtyOptionChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Casualties', style: TextStyle(color: Colors.white, fontSize:SizeConfig.blockSizeHorizontal * 3.5)),
        Row(
          children: [
            Radio<String?>(
              value: 'Yes',
              groupValue: selectedCasualtyOption,
              onChanged: onCasualtyOptionChanged,
              activeColor: primaryColor,
            ),
            const Text('Yes', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 32),
            Radio<String?>(
              value: 'No',
              groupValue: selectedCasualtyOption,
              onChanged: onCasualtyOptionChanged,
              activeColor: primaryColor,
            ),
            const Text('No', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}