/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import 'admin_view_news_list.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF06302B),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color:Color(0xFF03624C),
              ),
              iconSize: 28,
            ),
          ),
        ),
        title: const Text(
          'ADMIN DASHBOARD',
          style: TextStyle(
            color: Color(0xFFF1F7F6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double contentWidth = constraints.maxWidth > 600
                ? 600
                : constraints.maxWidth * 0.9;

            return Center(
              child: Container(
                width: contentWidth,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Container(
                      height: 1,
                      color: const Color(0xFF00DF81),
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsListView(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00DF81),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'NEWS MANAGEMENT',
                        style: TextStyle(
                          color: Color(0xFF021B1A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    OutlinedButton(
                      onPressed: () {
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF021B1A),
                        side: const BorderSide(
                          color: Color(0xFF00DF81),
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'TASK 2',
                        style: TextStyle(
                          color: Color(0xFFF1F7F6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF021B1A),
                        side: const BorderSide(
                          color: Color(0xFF00DF81),
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'TASK 3',
                        style: TextStyle(
                          color: Color(0xFFF1F7F6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF021B1A),
                        side: const BorderSide(
                          color: Color(0xFF00DF81),
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'TASK 4',
                        style: TextStyle(
                          color: Color(0xFFF1F7F6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}