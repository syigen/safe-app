import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/main_page.dart';

class NotificationItem extends StatelessWidget {
  final IconData? icon;
  final String message;
  final String time;
  final bool showMapButton;
  final String? iconText;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    this.icon,
    required this.message,
    required this.time,
    required this.showMapButton,
    this.iconText,
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
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
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
                  color: Color(0xFF0A3937),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: iconText != null
                      ? Text(
                    iconText!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                      : Icon(
                    icon!,
                    color: Colors.white,
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
                        color: Colors.white,
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
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        if (showMapButton)
                          GestureDetector(
                            onTap: () {
                              if (kDebugMode) {
                                print('Navigating to map for: $message');
                              }
                              // TODO: Implement map navigation
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00FF9D),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'See on map',
                                style: TextStyle(
                                  color: Color(0xFF032221),
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
