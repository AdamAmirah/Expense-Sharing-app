import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/DatabaseManager/DatabaseManager.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// registration with email and password

  Future createNewUser(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await DatabaseManager()
          .createUserData(name, 'Male', 100, result.user!.uid);
      return result.user;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
// sign with email and password

  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

// signout

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
