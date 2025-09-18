import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> registerWithMobile(String mobile, String password) async {
    final email = "$mobile@civicapp.com"; // use mobile as UserID
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<User?> loginWithMobile(String mobile, String password) async {
    final email = "$mobile@civicapp.com";
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<void> logout() async => _auth.signOut();
}
