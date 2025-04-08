/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../pages/main_page.dart';

class NotificationItem extends StatelessWidget {
  final IconData? icon;
  final String message;
  final String time;
  final bool showMapButton;
  final String? iconText;
  final LatLng? location;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    this.icon,
    required this.message,
    required this.time,
    required this.showMapButton,
    this.iconText,
    this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final mainPageState = context.findAncestorStateOfType<MainPageState>();

    return InkWell(
      onTap: onTap,
      splashColor: Colors.white.withValues(alpha: 0.1),
      highlightColor: Colors.white.withValues(alpha: 0.05),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF707D7D),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFAACBC4),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: iconText != null
                      ? Text(
                    iconText!,
                    style: const TextStyle(
                      color: Color(0xFF03624C),
                      fontWeight: FontWeight.w500,
                    ),
                  )
                      : Icon(
                    icon!,
                    color: const Color(0xFF03624C),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        color: Color(0xFFF1F7F6),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            color: Color(0xFFAACBC4),
                            fontSize: 14,
                          ),
                        ),
                        if (showMapButton && location != null)
                          GestureDetector(
                            onTap: () {
                              if (mainPageState != null && location != null) {
                                mainPageState.navigateToMapWithLocation(location: location!);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00FF81),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'See on map',
                                style: TextStyle(
                                  color: Color(0xFF021B1A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}