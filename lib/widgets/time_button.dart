import 'package:flutter/material.dart';

class TimeButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  TimeButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? Color(0xFF00FF9D) : Colors.transparent,
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: Color(0xFF00FF9D)),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Color(0xFF00FF9D),
          ),
        ),
      ),
    );
  }
}
