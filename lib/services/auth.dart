import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static Future<User?> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception('Error occured!');
    }
    print("cannot");
    return null;
  }

  static Future<User?> signInWithEmailPassword(
      {required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    } catch (e) {
      throw Exception('Error occured!');
    }
    return null;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<User?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  static Future<void> refreshUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
  }
}
