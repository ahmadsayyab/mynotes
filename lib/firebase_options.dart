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
    apiKey: 'AIzaSyAJs_MX2QcAvxFtc9QUnuS28x6JYXKplPc',
    appId: '1:483620979442:web:74a6c7e3a6b588228f066b',
    messagingSenderId: '483620979442',
    projectId: 'mynotes-firstflutter-pro-d6369',
    authDomain: 'mynotes-firstflutter-pro-d6369.firebaseapp.com',
    storageBucket: 'mynotes-firstflutter-pro-d6369.appspot.com',
    measurementId: 'G-701BQWQJD1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDI9l2ozYp_clTX2f17CjI7X2yYqTitsY4',
    appId: '1:483620979442:android:fc8e6b8769bd5dc28f066b',
    messagingSenderId: '483620979442',
    projectId: 'mynotes-firstflutter-pro-d6369',
    storageBucket: 'mynotes-firstflutter-pro-d6369.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfnO2APPq1Oa8aaRVU57H1GyFScsV1Pgs',
    appId: '1:483620979442:ios:67dd24497b5fe6668f066b',
    messagingSenderId: '483620979442',
    projectId: 'mynotes-firstflutter-pro-d6369',
    storageBucket: 'mynotes-firstflutter-pro-d6369.appspot.com',
    iosClientId: '483620979442-gp1j65vcrmjrckp566cddfpchr8pm89h.apps.googleusercontent.com',
    iosBundleId: 'com.makingstuff.mynotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfnO2APPq1Oa8aaRVU57H1GyFScsV1Pgs',
    appId: '1:483620979442:ios:67dd24497b5fe6668f066b',
    messagingSenderId: '483620979442',
    projectId: 'mynotes-firstflutter-pro-d6369',
    storageBucket: 'mynotes-firstflutter-pro-d6369.appspot.com',
    iosClientId: '483620979442-gp1j65vcrmjrckp566cddfpchr8pm89h.apps.googleusercontent.com',
    iosBundleId: 'com.makingstuff.mynotes',
  );
}