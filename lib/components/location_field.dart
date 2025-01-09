import 'package:flutter/material.dart';

class LocationField extends StatelessWidget {
  final TextEditingController locationController;
  final Color primaryColor;

  LocationField({
    required this.locationController,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationLabel(),
        _buildLocationInput(),
      ],
    );
  }

  Widget _buildLocationLabel() {
    return Text(
      'Location',
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _buildLocationInput() {
    return TextField(
      controller: locationController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        suffixIcon: Icon(Icons.edit, color: primaryColor),
      ),
    );
  }
}
