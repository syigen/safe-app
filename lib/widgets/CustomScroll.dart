/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return RawScrollbar(
      controller: details.controller,
      thumbColor: const Color(0xFF00DF81),
      radius: const Radius.circular(20),
      thickness: 6,
      thumbVisibility: true,
      child: child,
    );
  }
}