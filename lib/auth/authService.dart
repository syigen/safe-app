
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthServices{
  final SupabaseClient supabase ;

  AuthServices({required SupabaseClient? client})  // Add 'required' and make it nullable
      : supabase = client ?? Supabase.instance.client;


  Future<AuthResponse> signInWithEmailandPassword(String email , String password) async{
    return await supabase.auth.signInWithPassword(email: email,password: password);

  }

  Future<AuthResponse> signUPWithEmailansPassword(String email, String password) async{

    return await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut()async{
    await supabase.auth.signOut();
  }

  String? getCurrentUserEmail(){

    final session =supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }


  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'my.scheme://my-host',
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  Future<void> signInWithGitHub() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: kIsWeb ? null : 'my.scheme://my-host',
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } catch (e) {
      throw Exception('GitHub sign-in failed: $e');
    }
  }

}