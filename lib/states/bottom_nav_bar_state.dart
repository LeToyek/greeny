
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final bottomNavProvider =
    StateNotifierProvider<BottomNavNotifier, int>((ref) => BottomNavNotifier());

class BottomNavNotifier extends StateNotifier<int> {
  int get value => state;

  set value(int index) => state = index;

  BottomNavNotifier() : super(2) {
    value = Hive.box('prefs').get('navIndex', defaultValue: 2) as int;
  }
  void setValueToDB(int index) {
    value = index;
    Hive.box('prefs').put('navIndex', value);
  }
}
