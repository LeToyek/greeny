import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/services/auth.dart';
import 'package:greenify/services/users.dart';

class UsersNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  UsersServices usersServices;

  UsersNotifier({required this.usersServices})
      : super(const AsyncValue.loading());
  Future<void> getUsers() async {
    try {
      final users = await UsersServices().getUsers();
      state = AsyncValue.data(users);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getUser() async {
    try {
      final authUser = FireAuth.getCurrentUser();
      final user = await usersServices.getUserById(authUser!.uid);
      state = AsyncValue.data([user]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception(e);
    }
  }

  void createNull() {
    try {
      state = const AsyncValue.data([]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      state = const AsyncLoading();
      final authUser = await FireAuth.registerUser(
          email: email, password: password, name: name);
      final userMod = await usersServices.getUserById(authUser!.uid);
      state = AsyncValue.data([userMod]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      state = const AsyncLoading();
      final authUser = await FireAuth.signInWithGoogle();
      final userMod = await usersServices.getUserById(authUser!.uid);
      state = AsyncValue.data([userMod]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> basicLogin(
      {required String email, required String password}) async {
    try {
      state = const AsyncLoading();
      final authUser = await FireAuth.signInWithEmailPassword(
          email: email, password: password);
      final userMod = await usersServices.getUserById(authUser!.uid);
      state = AsyncValue.data([userMod]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logOut() async {
    try {
      FireAuth.signOut();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception(e);
    }
  }

  Future<void> updateProfilePhoto(String? oldUrl) async {
    try {
      state = const AsyncLoading();
      String photoUrl = await UsersServices().updateProfilePhoto(oldUrl);
      final authUser = FireAuth.getCurrentUser();
      UserModel user = await usersServices.getUserById(authUser!.uid);
      user.imageUrl = photoUrl;
      state = AsyncValue.data([user]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final usersProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>(
        (ref) => UsersNotifier(usersServices: UsersServices())..getUsers());

final singleUserProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>(
        (ref) => UsersNotifier(usersServices: UsersServices())..getUser());

final authUserProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>(
        (ref) => UsersNotifier(usersServices: UsersServices())..createNull());
