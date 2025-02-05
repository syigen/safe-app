/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class CircularBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final EdgeInsets padding;

  const CircularBackButton({
    Key? key,
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.padding = const EdgeInsets.only(left: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25), // Increased border radius
          onTap: onPressed ?? () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(4), // Increased padding around icon
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 0.5,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: iconColor,
              size: 30, // Kept the icon size as in your code
            ),
          ),
        ),
      ),
    );
  }
}