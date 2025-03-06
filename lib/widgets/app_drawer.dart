import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_app/pages/admin_dashboard.dart';
import 'package:safe_app/services/auth_service.dart';
import '../components/update_user_profile.dart';

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authService = AuthService(authClient: SupabaseAuthClient());
  return authService.getUserProfile();
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  final authService = AuthService(authClient: SupabaseAuthClient());
  return authService.getUserAdminStatus();
});

class AppDrawer extends ConsumerStatefulWidget {
  final Function(BuildContext) onLogout;

  const AppDrawer({
    super.key,
    required this.onLogout,
    required AuthService authService,
  });

  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends ConsumerState<AppDrawer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh user profile and admin status every time the drawer opens
    ref.refresh(userProfileProvider);
    ref.refresh(isAdminProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF032221),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(userProfileProvider);
        },
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => UpdateUserProfile(authService: AuthService(authClient: SupabaseAuthClient())),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF021B1A),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Fetch and display user profile
                      Consumer(
                        builder: (context, ref, child) {
                          final userProfileAsync = ref.watch(userProfileProvider);

                          return userProfileAsync.when(
                            data: (profileData) {
                              final String fullName = profileData?['fullName'] ?? 'User';
                              final String avatarUrl = profileData?['avatarUrl'] ?? '';

                              return Column(
                                children: [
                                  // Profile image
                                  avatarUrl.isNotEmpty
                                      ? CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(avatarUrl),
                                    onBackgroundImageError: (exception, stackTrace) {
                                    },
                                  )
                                      : const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: AssetImage('assets/user/default.png'),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Hello $fullName',
                                    style: const TextStyle(
                                      color: Color(0xFFF1F7F6),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stackTrace) => const Text('Error loading profile'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.emergency_outlined, color: Color(0xFFFF0000), size: 30),
              title: const Text(
                'Emergency',
                style: TextStyle(color: Color(0xFFFF0000), fontSize: 22, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white, size: 30),
              title: const Text('About', style: TextStyle(color: Colors.white, fontSize: 22)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final isAdminAsync = ref.watch(isAdminProvider);

                return isAdminAsync.when(
                  data: (isAdmin) {
                    return isAdmin
                        ? ListTile(
                      leading: const Icon(Icons.settings, color: Colors.white, size: 30),
                      title: const Text('Admin', style: TextStyle(color: Colors.white, fontSize: 22)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminDashboard(),
                          ),
                        );
                      },
                    )
                        : Container();
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => const Text('Error fetching admin status'),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onLogout(context);
                },
                icon: const Icon(Icons.logout, color: Colors.white, size: 20,),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF ),
                    fontSize: 18,
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
      ),
    );
  }
}
