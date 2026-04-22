import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActividadesScreen extends StatelessWidget {
  const ActividadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante para añadir actividades
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _mostrarDialogoNuevaActividad(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder(
        // Escuchamos la colección 'actividades' en tiempo real
        stream: FirebaseFirestore.instance.collection('actividades').orderBy('fecha_evento').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.green, size: 40),
                  title: Text(doc['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${doc['descripcion']}\n📍 ${doc['lugar']}"),
                  trailing: Text(doc['hora']),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Función para proponer actividad (Sube datos a Firebase)
  void _mostrarDialogoNuevaActividad(BuildContext context) {
    final tituloController = TextEditingController();
    final descController = TextEditingController();
    final lugarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Proponer Actividad"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: tituloController, decoration: const InputDecoration(labelText: "Nombre de la actividad")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Descripción")),
            TextField(controller: lugarController, decoration: const InputDecoration(labelText: "¿Dónde será?")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('actividades').add({
                'titulo': tituloController.text,
                'descripcion': descController.text,
                'lugar': lugarController.text,
                'hora': "18:00 PM", // Por ahora estático para prueba
                'fecha_evento': DateTime.now(), 
              });
              Navigator.pop(context);
            },
            child: const Text("Publicar"),
          )
        ],
      ),
    );
  }
}