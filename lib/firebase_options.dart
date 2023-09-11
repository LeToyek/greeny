// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBmj_TqdSJ_bQ-JG0nrTg3S6xQTL4QTJxc',
    appId: '1:408888696472:web:8d6e4bcd79e7f92c707aed',
    messagingSenderId: '408888696472',
    projectId: 'greenify-f07ad',
    authDomain: 'greenify-f07ad.firebaseapp.com',
    storageBucket: 'greenify-f07ad.appspot.com',
    measurementId: 'G-K57BNC94TJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLr8rD4R9TTMotUX_hNyw7racGWY8TOBU',
    appId: '1:408888696472:android:71eeacd4385143f3707aed',
    messagingSenderId: '408888696472',
    projectId: 'greenify-f07ad',
    storageBucket: 'greenify-f07ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBC5kI9sSUgsmy6at4-_EJmODT_kLs63SE',
    appId: '1:408888696472:ios:37b226c6d2a3ea86707aed',
    messagingSenderId: '408888696472',
    projectId: 'greenify-f07ad',
    storageBucket: 'greenify-f07ad.appspot.com',
    androidClientId: '408888696472-1tttp8rbpa3bin6fn5i9l4h50m1gbd7q.apps.googleusercontent.com',
    iosClientId: '408888696472-dnk5ecvg2n9qk4b6qaidjhss7jti4lh0.apps.googleusercontent.com',
    iosBundleId: 'com.example.greenify',
  );
}
