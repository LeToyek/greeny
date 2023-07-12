import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/auth.dart';
import 'package:greenify/services/users.dart';

class UserActionNotifier extends StateNotifier<AsyncValue<User?>> {
  UserActionNotifier() : super(const AsyncData(null));

  Future<void> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      state = const AsyncLoading();
      await FireAuth.registerUser(email: email, password: password, name: name);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> basicLoginUser(
      {required String email, required String password}) async {
    try {
      state = const AsyncLoading();
      await FireAuth.signInWithEmailPassword(email: email, password: password);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> googleLoginUser() async {
    try {
      state = const AsyncLoading();
      User? user = await FireAuth.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logoutUser() async {
    try {
      FireAuth.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> increaseUserLevel() async {
    try {
      await UsersServices().increaseLevelUser();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> increaseUserExp(int exp) async {
    try {
      await UsersServices().increaseExpUser(exp);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final userActionProvider =
    StateNotifierProvider<UserActionNotifier, AsyncValue<User?>>(
        (ref) => UserActionNotifier());
