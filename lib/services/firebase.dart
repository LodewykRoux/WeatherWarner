import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future registerEmailAndPass(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return FirebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return FirebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//todo sign out
//Sign out

}
