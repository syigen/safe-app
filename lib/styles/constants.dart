import 'package:flutter/material.dart';
import '../utils/size_config.dart';

const Color primaryColor = Color(0xFF00FF9D);
const Color backgroundColor = Color(0xFF021B1A);

TextStyle getResponsiveHeadingStyle(BuildContext context) {
  SizeConfig().init(context);
  return TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.blockSizeHorizontal * 4, // 4% of screen width
  );
}

TextStyle getResponsiveBodyStyle(BuildContext context) {
  SizeConfig().init(context);
  return TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.blockSizeHorizontal * 3.5, // 3.5% of screen width
  );
}