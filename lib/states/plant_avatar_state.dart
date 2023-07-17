import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlantAvatarNotifier extends StateNotifier<PageController> {
  int pageIndex = 0;
  PlantAvatarNotifier() : super(PageController(initialPage: 0));

  void setPage(int index) {
    state.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    pageIndex = index;
  }

  int getPage() {
    return pageIndex;
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
