import 'package:flutter/material.dart';
import 'package:safe_app/pages/admin_dashboard.dart';

import '../components/user_profile_popup.dart';

class AppDrawer extends StatelessWidget {
  final Function(BuildContext) onLogout;

  const AppDrawer({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF032221),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ProfilePopup(),
              );
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF021B1A),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                      AssetImage('assets/images/profile_image.png'),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Hello User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading:
            const Icon(Icons.emergency_outlined, color: Colors.redAccent, size: 30,),
            title: const Text('EMERGENCY',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('About', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title:
            const Text('Admin', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboard(),
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onLogout(context);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1F1F),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}