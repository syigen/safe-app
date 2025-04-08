/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

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