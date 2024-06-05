import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get authStateStream => _auth.authStateChanges();
  // String? myUid;
  String? get myUid => _auth.currentUser?.uid;

  Future<String> createUser(String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = credential.user;
    if (user == null) {
      throw 'authService-createUser: user is null';
    }
    return user.uid;
  }

  Future<String> signIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = credential.user;
    if (user == null) {
      throw 'authService-signIn: user is null';
    }
    return user.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
