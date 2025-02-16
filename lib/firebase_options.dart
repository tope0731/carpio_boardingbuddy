// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBFMa1_0Y_604Lfd7O8wwUAVRwcZwKaez0',
    appId: '1:242093013943:web:535f7790a25d38124c0632',
    messagingSenderId: '242093013943',
    projectId: 'boardingbuddy-db2d7',
    authDomain: 'boardingbuddy-db2d7.firebaseapp.com',
    storageBucket: 'boardingbuddy-db2d7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA84GRZI_4LPxiPXRJ7olUgZKejz5ncyyM',
    appId: '1:242093013943:android:015f6b4cea3d965c4c0632',
    messagingSenderId: '242093013943',
    projectId: 'boardingbuddy-db2d7',
    storageBucket: 'boardingbuddy-db2d7.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBFMa1_0Y_604Lfd7O8wwUAVRwcZwKaez0',
    appId: '1:242093013943:web:c8668ad7000e192c4c0632',
    messagingSenderId: '242093013943',
    projectId: 'boardingbuddy-db2d7',
    authDomain: 'boardingbuddy-db2d7.firebaseapp.com',
    storageBucket: 'boardingbuddy-db2d7.appspot.com',
  );
}
