import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/config/theme.dart';
import 'package:greenify/routes/index.dart';
import 'package:greenify/services/background_service.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:greenify/utils/notification_helper.dart';
import 'package:hive/hive.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final BackgroundServices service = BackgroundServices();

  service.initIsolate();
  await AndroidAlarmManager.initialize();

  await Firebase.initializeApp();
  await NotificationHelper().initializeNotification();

  await dotenv.load();
  final Directory tempDir = await getTemporaryDirectory();
  Hive.init(tempDir.path);
  await Hive.openBox('prefs');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeUsed = ref.watch(themeProvider);
    final router = ref.watch(appRouteProvider);

    return MaterialApp.router(
      color: themeUsed == ThemeMode.light
          ? lightTheme.colorScheme.background
          : darkTheme.colorScheme.background,
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      title: "Greenify",
      routerConfig: router,
      themeMode: themeUsed,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
