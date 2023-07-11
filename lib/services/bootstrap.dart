import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Bootstrap {
  static void checkUserExist(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    user == null ? context.go('/login') : context.go('/');
  }
}
