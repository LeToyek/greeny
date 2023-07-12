import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/user_model.dart';
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
      final user = await usersServices.getUser();

      state = AsyncValue.data([user]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateProfilePhoto(String? oldUrl) async {
    try {
      print("oldUrl => $oldUrl");
      state = const AsyncLoading();
      String photoUrl = await UsersServices().updateProfilePhoto(oldUrl);
      UserModel user = await usersServices.getUser();
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
