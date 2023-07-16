import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/storage.dart';

class StorageNotifier extends StateNotifier<AsyncValue<String>> {
  final StorageService storage;
  StorageNotifier({required this.storage})
      : super(const AsyncValue.data("waiting"));

  Future<String> uploadFile() async {
    try {
      state = const AsyncLoading();
      String name = await storage.uploadFile();
      state = const AsyncValue.data("Success");
      return name;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
    return "Error";
  }
}

final fileUploadProvider =
    StateNotifierProvider<StorageNotifier, AsyncValue<String>>(
        (ref) => StorageNotifier(storage: StorageService()));
