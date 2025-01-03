import 'package:safe_app/auth/authService.dart';
import 'package:test/test.dart';

void main() {

  AuthServices authServices;

  group('Testing Auth Function', () {
    test('value should start at 0', () {

    });

    test('Test signInWithEmailandPassword ()', () {

      String email="pramodyahasin@gmail.com";
      String password = "12345";

      authServices.supabase.auth.signInWithPassword(email: email,password: password);

    });

    test('value should be decremented', () {

    });
  });
}