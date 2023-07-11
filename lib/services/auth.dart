import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  static Future<User?> signInWithGoogle() async {
    try {
      List<String> scopes = [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: scopes,
        clientId: dotenv.env['GOOGLE_CLIENT_ID'],
      ).signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception(
            'The account already exists with a different credential.');
      } else if (e.code == 'invalid-credential') {
        throw Exception(
            'Error occured while accessing credentials. Try again.');
      }
    } catch (e) {
      throw Exception('Error occured!');
    }
    return null;
  }

  static void signOut(BuildContext context) {
    if (context.mounted) context.go('/login');
    FirebaseAuth.instance.signOut();
  }

  static User? getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  static Future<void> refreshUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
  }
}
