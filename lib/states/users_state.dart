import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/user_model.dart';
import 'package:greenify/services/users.dart';

class UsersNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  UsersNotifier() : super(const AsyncValue.loading());
  Future<void> getUsers() async {
    try {
      print("testt");
      final users = await UsersServices().getUsers();
      state = AsyncValue.data(users);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final usersProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>(
        (ref) => UsersNotifier()..getUsers());
