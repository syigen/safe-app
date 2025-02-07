/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:safe_app/pages/main_page.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final mainPageState = context.findAncestorStateOfType<MainPageState>();
        if (mainPageState != null) {
          mainPageState.navigateToHome();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Service'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text('Service Page'),
        ),
      ),
    );
  }
}
