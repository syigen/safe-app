import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String currentFilter = 'All';

  // Sample notification data
  final List<Map<String, dynamic>> allNotifications = [
    {
      'icon': Icons.access_time,
      'message': 'A group of elephants has been sighted in close proximity to our Kapugala.',
      'time': '36m ago',
      'showMapButton': true,
      'isAlert': true,
    },
    {
      'icon': Icons.access_time,
      'message': 'Aliquam pulvinar vestibulum blandit. Donec sed nisl libero.',
      'time': '2h ago',
      'showMapButton': true,
      'isAlert': true,
    },
    {
      'iconText': 'AN',
      'message': 'Amet, pulvinar egestas leo egestas nulla id mollis',
      'time': '11:24 PM',
      'showMapButton': false,
      'isAlert': false,
    },
    {
      'icon': Icons.location_on,
      'message': 'Aliquam pulvinar vestibulum blandit. Donec sed nisl libero. Fusce dignissim luctus',
      'time': '9:12 AM',
      'showMapButton': false,
      'isAlert': false,
    },
    {
      'icon': Icons.access_time,
      'message': 'Duis aute irure dolor in reprehenderit in voluptate',
      'time': 'Yesterday, 11:55 PM',
      'showMapButton': true,
      'isAlert': true,
    },
    {
      'icon': Icons.access_time,
      'message': 'Aliquam pulvinar vestibulum blandit. Donec sed nisl libero. Fusce dignissim luctus',
      'time': '24 September 2023, 8:44 PM',
      'showMapButton': true,
      'isAlert': true,
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (currentFilter == 'All') {
      return allNotifications;
    } else {
      return allNotifications.where((notification) => notification['isAlert']).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF032221),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  FilterButton(
                    text: 'All',
                    isSelected: currentFilter == 'All',
                    onTap: () => setState(() => currentFilter = 'All'),
                  ),
                  const SizedBox(width: 12),
                  FilterButton(
                    text: 'Alerts',
                    isSelected: currentFilter == 'Alerts',
                    onTap: () => setState(() => currentFilter = 'Alerts'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredNotifications.length,
                itemBuilder: (context, index) {
                  final notification = filteredNotifications[index];
                  return NotificationItem(
                    icon: notification['icon'],
                    message: notification['message'],
                    time: notification['time'],
                    showMapButton: notification['showMapButton'],
                    iconText: notification['iconText'],
                    onTap: () {
                      // Handle notification tap
                      if (kDebugMode) {
                        print('Tapped notification: ${notification['message']}');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00FF9D) : const Color(0xFF0A3937),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF032221) : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

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
                              // Handle map button tap
                              if (kDebugMode) {
                                print('Map button tapped for: $message');
                              }
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