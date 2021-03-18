import 'package:firebase_auth/firebase_auth.dart';
import 'package:task1/main.dart';
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UIDUser _userFromFirebaseUser1(User user) {
    return user != null ? UIDUser(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential resultsign = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = resultsign.user;
      return _userFromFirebaseUser1(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future registerWithEmailAndPassword(String email, String password,String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await result.user.updateProfile(displayName: name);
      User user = result.user;
      return _userFromFirebaseUser1(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}