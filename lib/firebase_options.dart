import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBGCDLnU-bdfu6szUZ_yZBz1jZqRAqTWm8',
    authDomain: 'rbc-app-3d3a2.firebaseapp.com',
    projectId: 'rbc-app-3d3a2',
    storageBucket: 'rbc-app-3d3a2.firebasestorage.app',
    messagingSenderId: '150831279839',
    appId: '1:150831279839:web:bed428b99806f08f77436a',
  );
}