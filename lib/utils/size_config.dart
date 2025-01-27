import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double textScaleFactor;
  static late double devicePixelRatio;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    textScaleFactor = _mediaQueryData.textScaleFactor;

    blockSizeHorizontal = screenWidth / 100; // Percentage-based
    blockSizeVertical = screenHeight / 100;  // Percentage-based
  }

  // You can use this function to scale text sizes based on screen density
  static double getTextScale(double size) {
    return size * textScaleFactor;
  }

  // For higher resolution devices, you can consider the devicePixelRatio
  static double getScaledSize(double size) {
    return size * devicePixelRatio;
  }
}
