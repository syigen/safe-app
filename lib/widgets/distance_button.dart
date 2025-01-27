import 'package:flutter/material.dart';

class DistanceButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final double fontSize;
  final double buttonHeight;

  const DistanceButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    required this.fontSize,
    required this.buttonHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? const Color(0xFF00FF9D) : Colors.transparent,
          ),
          alignment: Alignment.center,
          side: MaterialStateProperty.all(
            const BorderSide(color: Color(0xFF00FF9D)),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: buttonHeight * 0.2), // Adjust height
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
