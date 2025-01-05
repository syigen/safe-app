import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../lib/auth/authService.dart';

void main() {
  late SupabaseClient supabase;
  late AuthServices authService;

  setUp(() {
    supabase = SupabaseClient(
      'https://htdopvquzxdywjsqwkpb.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh0ZG9wdnF1enhkeXdqc3F3a3BiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU3MTQ0MTAsImV4cCI6MjA1MTI5MDQxMH0.v-1gCbQV1Yd2ipeVBz3p-gY6TwP75fuqEbHzHitc4ZA',
    );
    authService = AuthServices(client: supabase);
  });

  group('Authentication Integration Tests', () {
    test('Sign In with Email and Password', () async {
      final email = 'hasinpramodyahasin@gmail.com';
      final password = 'Pramo@123';

      try {
        final response = await authService.signInWithEmailandPassword(email, password);

        if (response.session != null) {
          print('Sign In Successful:');
          print('   - Email: $email');
          print('   - Password: $password');
        } else {
          print('Sign In Failed: No session created');
        }
      } catch (e) {
        print('Sign In Error: $e');
      }
    });

    test('Sign Up with Email and Password', () async {
      final email = 'newuser${DateTime.now().millisecondsSinceEpoch}@example.com';
      final password = 'TestPassword123!';

      try {
        await authService.signUPWithEmailansPassword(email, password);
        print('Sign Up Successful:');
        print(' Email: $email');
        print(' Password: $password');
      } catch (e) {
        print('Sign Up Error: $e');
      }
    });

    test('Get Current User Email After Sign In', () async {
      try {
        final email = authService.getCurrentUserEmail();
        if (email != null) {
          print('Current User Check Successful:');
          print('   - Current User Email: $email');
        } else {
          print('No User Currently Logged In');
        }
      } catch (e) {
        print('Current User Check Error: $e');
      }
    });

    test('Sign Out', () async {
      try {
        await authService.signOut();
        final currentUser = authService.getCurrentUserEmail();

        if (currentUser == null) {
          print('Sign Out Successful:');
          print('   - User session cleared');
        } else {
          print('Sign Out Failed: User still logged in');
        }
      } catch (e) {
        print('Sign Out Error: $e');
      }
    });

    // Note: OAuth tests will need manual verification due to browser interaction
    test('Sign In with Google (Manual Check Required)', () async {
      try {

        await authService.signInWithGoogle();
        print('ℹGoogle Sign In flow started - check browser for OAuth flow');
      } catch (e) {
        print('Google Sign In Error: $e');
      }
    });

    test('Sign In with GitHub (Manual Check Required)', () async {
      try {
        await authService.signInWithGitHub();
        print('GitHub Sign In flow started - check browser for OAuth flow');
      } catch (e) {
        print('GitHub Sign In Error: $e');
      }
    });
  });
}
