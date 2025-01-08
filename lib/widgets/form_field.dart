import 'package:flutter/material.dart';

class FormFieldWidget extends StatelessWidget {
  final String label;
  final String value;
  final String? secondValue;

  FormFieldWidget({
    required this.label,
    required this.value,
    this.secondValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            if (secondValue != null) ...[
              SizedBox(width: 16),
              Expanded(
                child: Text(secondValue!, style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
            Icon(Icons.edit, color: Color(0xFF00FF9D), size: 20),
          ],
        ),
        Divider(color: Colors.grey[600]),
        SizedBox(height: 24),
      ],
    );
  }
}
