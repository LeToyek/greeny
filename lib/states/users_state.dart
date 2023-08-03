import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/services/auth_service.dart';
import 'package:greenify/services/users_service.dart';

class UsersNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  UsersServices usersServices;
  String? visitedUser;

  UsersNotifier({required this.usersServices})
      : super(const AsyncValue.data([]));
  Future<void> getUsers() async {
    try {
      state = const AsyncValue.loading();
      final users = await UsersServices().getUsers();
      state = AsyncValue.data(users);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getUser() async {
    try {
      state = const AsyncValue.loading();
      final authUser = FireAuth.getCurrentUser();
      if (authUser == null) {
        state = const AsyncValue.data([]);
        return;
      }
      final user = await usersServices.getUserById(id: authUser.uid);
      state = AsyncValue.data([user]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      print(StackTrace.current);
      throw Exception(
        e,
      );
    }
  }

  void setVisitedUser({String? id}) {
    id ??= FireAuth.getCurrentUser()!.uid;
    visitedUser = id;
  }

  bool isSelf() {
    final authUser = FireAuth.getCurrentUser();
    if (authUser == null) {
      return false;
    }
    return authUser.uid == visitedUser;
  }

  Future<void> getUserById(String id) async {
    try {
      state = const AsyncValue.loading();
      final user = await usersServices.getUserById(id: id);
      visitedUser = id;
      state = AsyncValue.data([user]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      throw Exception(e);
    }
  }

  Future<void> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      state = const AsyncValue.loading();
      final authUser = await FireAuth.registerUser(
          email: email, password: password, name: name);
      final userMod = await usersServices.getUserById(id: authUser!.uid);
      state = AsyncValue.data([userMod]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      state = const AsyncValue.loading();
      final authUser = await FireAuth.signInWithGoogle();
      final userMod = await usersServices.getUserById(id: authUser!.uid);
      state = AsyncValue.data([userMod]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> basicLogin(
      {required String email, required String password}) async {
    try {
      state = const AsyncValue.loading();
      final authUser = await FireAuth.signInWithEmailPassword(
          email: email, password: password);
      print("auth user: $authUser");
      if (authUser == null) {
        print("User not found");
        state = AsyncValue.error("User not found", StackTrace.current);
        throw Exception("User not found");
      }
      final userMod = await usersServices.getUserById(id: authUser.uid);
      state = AsyncValue.data([userMod]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      throw Exception("User tidak ditemukan");
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
      state = const AsyncValue.loading();
      String photoUrl = await UsersServices().updateProfilePhoto(oldUrl);
      final authUser = FireAuth.getCurrentUser();
      UserModel user = await usersServices.getUserById(id: authUser!.uid);
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

final userClientProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>((ref) {
  return UsersNotifier(usersServices: UsersServices())..getUsers();
});
