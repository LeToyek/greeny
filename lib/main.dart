import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/config/theme.dart';
import 'package:greenify/routes/index.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      title: "Greenify",
      routerConfig: router,
      themeMode: themeUsed,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
