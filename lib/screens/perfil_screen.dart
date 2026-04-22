import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID del usuario que está conectado ahorita
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        // Vamos a buscar a la colección 'usuarios' el documento con nuestro ID
        future: FirebaseFirestore.instance.collection('usuarios').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No se encontraron datos del usuario"));
          }

          // Extraemos los datos del documento
          Map<String, dynamic> datos = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 20),
                itemPerfil("Correo", datos['email']),
                itemPerfil("Municipio", datos['municipio']),
                itemPerfil("Zona", datos['zona']),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text("Cerrar Sesión"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Un pequeño diseño para cada línea de dato
  Widget itemPerfil(String titulo, String valor) {
    return Card(
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(valor, style: const TextStyle(fontSize: 18, color: Colors.blueGrey)),
      ),
    );
  }
}