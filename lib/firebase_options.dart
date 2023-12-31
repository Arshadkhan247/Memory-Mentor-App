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
        return macos;
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
    apiKey: 'AIzaSyDGgUyjlhIhpERNx_wJhOWxMBlJNUCmA70',
    appId: '1:758174388820:web:89d7f7103737546f9713c1',
    messagingSenderId: '758174388820',
    projectId: 'mentor-4d9f4',
    authDomain: 'mentor-4d9f4.firebaseapp.com',
    storageBucket: 'mentor-4d9f4.appspot.com',
    measurementId: 'G-BVQJ8SRP7Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9XI6tTqQMGDba0n3kNOLMswZDGBO2H2g',
    appId: '1:758174388820:android:a8e848e052a5e41c9713c1',
    messagingSenderId: '758174388820',
    projectId: 'mentor-4d9f4',
    storageBucket: 'mentor-4d9f4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBii7gF-2Qep-LcrQxURBe8TjW8xlMRHrM',
    appId: '1:758174388820:ios:66dd2ccc55c28c4f9713c1',
    messagingSenderId: '758174388820',
    projectId: 'mentor-4d9f4',
    storageBucket: 'mentor-4d9f4.appspot.com',
    iosBundleId: 'com.example.mentor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBii7gF-2Qep-LcrQxURBe8TjW8xlMRHrM',
    appId: '1:758174388820:ios:d06f7d1ba823ca359713c1',
    messagingSenderId: '758174388820',
    projectId: 'mentor-4d9f4',
    storageBucket: 'mentor-4d9f4.appspot.com',
    iosBundleId: 'com.example.mentor.RunnerTests',
  );
}
