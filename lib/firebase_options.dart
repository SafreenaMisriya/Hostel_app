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
        return ios;
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
    apiKey: 'AIzaSyDg22m36Ju5gd_km2eUMallnhfRvjzTdBU',
    appId: '1:76851505485:web:bbecbd899b5c45f8152f04',
    messagingSenderId: '76851505485',
    projectId: 'hostel-app-25b14',
    authDomain: 'hostel-app-25b14.firebaseapp.com',
    storageBucket: 'hostel-app-25b14.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuXZ1SPQ-SAMKxxM2B6nV9ZnZ21dE5N24',
    appId: '1:76851505485:android:7b0da83656008e3b152f04',
    messagingSenderId: '76851505485',
    projectId: 'hostel-app-25b14',
    storageBucket: 'hostel-app-25b14.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcZttkX0SRNYJ84tZroeDrEHnzGphuF7M',
    appId: '1:76851505485:ios:bd3abf0ac9f89762152f04',
    messagingSenderId: '76851505485',
    projectId: 'hostel-app-25b14',
    storageBucket: 'hostel-app-25b14.appspot.com',
    iosBundleId: 'com.example.hostelApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDg22m36Ju5gd_km2eUMallnhfRvjzTdBU',
    appId: '1:76851505485:web:c46c06ffdf8a499f152f04',
    messagingSenderId: '76851505485',
    projectId: 'hostel-app-25b14',
    authDomain: 'hostel-app-25b14.firebaseapp.com',
    storageBucket: 'hostel-app-25b14.appspot.com',
  );
}
