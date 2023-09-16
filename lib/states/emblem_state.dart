import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/emblem_model.dart';
import 'package:greenify/services/emblem_service.dart';

class EmblemNotifier extends StateNotifier<AsyncValue<List<EmblemModel>>> {
  final emblemService = EmblemService();
  EmblemNotifier() : super(const AsyncValue.loading());

  Future<void> getEmblems() async {
    try {
      state = const AsyncValue.loading();
      final emblems = await emblemService.getEmblems();
      state = AsyncValue.data(emblems);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final emblemProvider =
    StateNotifierProvider<EmblemNotifier, AsyncValue<List<EmblemModel>>>(
        (ref) => EmblemNotifier()..getEmblems());
