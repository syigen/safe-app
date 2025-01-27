import 'package:flutter/material.dart';

class TimeField extends StatelessWidget {
  final TextEditingController timeController;
  final Color primaryColor;

  TimeField({
    required this.timeController,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Font size responsive to screen width
    double labelFontSize = screenWidth * 0.045; // 4.5% of screen width for label font size
    double inputFontSize = screenWidth * 0.04;  // 4% of screen width for input font size
    double paddingHorizontal = screenWidth * 0.05; // Horizontal padding proportional to screen width

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal), // Add horizontal padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeLabel(labelFontSize),
          Expanded(
            child: _buildTimeInput(inputFontSize),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabel(double fontSize) {
    return Text(
      'Time',
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTimeInput(double fontSize) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextField(
        controller: timeController,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        enabled: false, // Disable the input field
        textAlign: TextAlign.end, // Align text inside the input to the right
        decoration: InputDecoration(
          border: InputBorder.none, // Remove underline
        ),
      ),
    );
  }
}
