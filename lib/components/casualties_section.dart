import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class CasualtiesSection extends StatelessWidget {
  final String selectedCasualtyOption;
  final ValueChanged<String?>? onCasualtyOptionChanged;
  final Color primaryColor;

  CasualtiesSection({
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
            Text('Yes', style: TextStyle(color: Colors.white)),
            SizedBox(width: 32),
            Radio<String?>(
              value: 'No',
              groupValue: selectedCasualtyOption,
              onChanged: onCasualtyOptionChanged,
              activeColor: primaryColor,
            ),
            Text('No', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
