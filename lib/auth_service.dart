import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registrarUsuario(String email, String password, String municipio, String zona) async {
    try {
      // 1. Crea el usuario en Firebase Authentication
      UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // 2. Si se creó bien, guarda los datos extra en Firestore
      if (res.user != null) {
        await _db.collection('usuarios').doc(res.user!.uid).set({
          'uid': res.user!.uid,
          'email': email,
          'municipio': municipio,
          'zona': zona,
          'fecha_registro': DateTime.now(),
        });
      }
      return res.user;
    } catch (e) {
      print("Error al registrar: $e");
      return null;
    }
  }
}