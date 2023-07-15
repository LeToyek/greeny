import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlantAvatarNotifier extends StateNotifier<PageController> {
  PlantAvatarNotifier()
      : super(PageController(initialPage: 0, viewportFraction: 0.8));

  void setPage(int index) {
    state.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    state.dispose();
    super.dispose();
  }
}

final plantAvatarProvider =
    StateNotifierProvider<PlantAvatarNotifier, PageController>((ref) {
  return PlantAvatarNotifier();
});
