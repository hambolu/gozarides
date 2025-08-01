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
        return macos;
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
    apiKey: 'AIzaSyBr7NjQE9bKs-bOiiOrVCvkUcb7kUFy8D0',
    appId: '1:1032430561578:web:c4f4a1e3b75fd0b8d21653',
    messagingSenderId: '1032430561578',
    projectId: 'gozarides-5e916',
    authDomain: 'gozarides-5e916.firebaseapp.com',
    storageBucket: 'gozarides-5e916.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1KczPWp3L9oPpsZb62ndBkleFYM46rAY',
    appId: '1:1032430561578:android:c3c6716920a6ff0ed21653',
    messagingSenderId: '1032430561578',
    projectId: 'gozarides-5e916',
    storageBucket: 'gozarides-5e916.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXQTJJMxph0uPYTOu2uqaODGdEO-WDlhk',
    appId: '1:1032430561578:ios:9be0fc9eca61ceaed21653',
    messagingSenderId: '1032430561578',
    projectId: 'gozarides-5e916',
    storageBucket: 'gozarides-5e916.firebasestorage.app',
    iosBundleId: 'com.example.gozarides',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXQTJJMxph0uPYTOu2uqaODGdEO-WDlhk',
    appId: '1:1032430561578:ios:9be0fc9eca61ceaed21653',
    messagingSenderId: '1032430561578',
    projectId: 'gozarides-5e916',
    storageBucket: 'gozarides-5e916.firebasestorage.app',
    iosBundleId: 'com.example.gozarides',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBr7NjQE9bKs-bOiiOrVCvkUcb7kUFy8D0',
    appId: '1:1032430561578:web:05f6eb600f12cafdd21653',
    messagingSenderId: '1032430561578',
    projectId: 'gozarides-5e916',
    authDomain: 'gozarides-5e916.firebaseapp.com',
    storageBucket: 'gozarides-5e916.firebasestorage.app',
  );
}
