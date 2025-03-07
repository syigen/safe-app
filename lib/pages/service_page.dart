/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import '../widgets/service_card.dart';
import 'main_page.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final mainPageState =
            context.findAncestorStateOfType<MainPageState>();
        if (mainPageState != null) {
          mainPageState.navigateToHome();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF032221),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'All Services and tools',
                  style: TextStyle(
                    color: Color(0xFFF1F7F6),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                        childAspectRatio: 163 / 80,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      children: [
                        ServiceCard(
                          title: 'Contacts',
                          icon: 'assets/icons/contact.png',
                          onTap: () {},
                        ),
                        ServiceCard(
                          title: 'Safety tips',
                          icon: 'assets/icons/safety.png',
                          onTap: () {},
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
