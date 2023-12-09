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
        return android;
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
    apiKey: 'AIzaSyDkW92fiugYqeC9we0LZzE0e97TzvOlozs',
    appId: '1:198366274201:web:4765646e9bdad3cf93ce08',
    messagingSenderId: '198366274201',
    projectId: 'project-workflow-app',
    authDomain: 'project-workflow-app.firebaseapp.com',
    storageBucket: 'project-workflow-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLL2vHyXmxpl3o7wYSax7vUh0xaMcAKmU',
    appId: '1:198366274201:android:fdc44e07d68de9da93ce08',
    messagingSenderId: '198366274201',
    projectId: 'project-workflow-app',
    storageBucket: 'project-workflow-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDL4IzMyuOFOTJpFybgOJJ8F4Y5LZzxL_I',
    appId: '1:198366274201:ios:65572ed33c63366293ce08',
    messagingSenderId: '198366274201',
    projectId: 'project-workflow-app',
    storageBucket: 'project-workflow-app.appspot.com',
    iosBundleId: 'com.example.projectWorkflowApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDL4IzMyuOFOTJpFybgOJJ8F4Y5LZzxL_I',
    appId: '1:198366274201:ios:fc91d3a62fc12c1093ce08',
    messagingSenderId: '198366274201',
    projectId: 'project-workflow-app',
    storageBucket: 'project-workflow-app.appspot.com',
    iosBundleId: 'com.example.projectWorkflowApp.RunnerTests',
  );
}
