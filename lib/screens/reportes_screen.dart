import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  final TextEditingController _detalleController = TextEditingController();
  
  double? latSeleccionada;
  double? lngSeleccionada;

  Future<void> _subirReporte(String detalle, String? imagenUrl, double? lat, double? lng) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inicia sesión para reportar")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('reportes').add({
        'usuario': user.displayName ?? "Vecino",
        'uID': user.uid,
        'detalle': detalle,
        'fecha': FieldValue.serverTimestamp(),
        'zona': "Otay", 
        'imagen': imagenUrl,
        'latitud': lat,
        'longitud': lng,
      });

      _detalleController.clear();
      setState(() {
        latSeleccionada = null;
        lngSeleccionada = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Reporte publicado con éxito!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al subir: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reportes')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error al cargar datos"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No hay reportes aún."));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              
              String fechaTxt = "Reciente";
              if (data['fecha'] != null) {
                DateTime fecha = (data['fecha'] as Timestamp).toDate();
                fechaTxt = "${fecha.day}/${fecha.month} - ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}";
              }

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(data['usuario'] ?? "Anónimo", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(fechaTxt),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Text(data['detalle'] ?? ""),
                    ),
                    
                    // BOTÓN PARA VER LA UBICACIÓN GUARDADA
                    if (data['latitud'] != null && data['longitud'] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => VerMapaDialog(
                                lat: data['latitud'],
                                lng: data['longitud'],
                              ),
                            );
                          },
                          icon: const Icon(Icons.location_on, color: Colors.red),
                          label: const Text("Ver ubicación en mapa"),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormulario(context),
        label: const Text("Reportar"),
        icon: const Icon(Icons.add_location_alt),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _mostrarFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20, left: 20, right: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Nuevo Reporte", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                controller: _detalleController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "¿Qué quieres reportar?", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {}, 
                    icon: const Icon(Icons.camera_alt), 
                    label: const Text("Foto")
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog<Map<String, double>>(
                        context: context,
                        builder: (context) => const SeleccionarMapaDialog(),
                      );
                      if (result != null) {
                        setModalState(() {
                          latSeleccionada = result['lat'];
                          lngSeleccionada = result['lng'];
                        });
                      }
                    }, 
                    icon: Icon(Icons.map, color: latSeleccionada != null ? Colors.green : Colors.grey), 
                    label: Text(latSeleccionada != null ? "Ubicación lista" : "Mapa")
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 45),
                  foregroundColor: Colors.white
                ),
                onPressed: () async {
                  if (_detalleController.text.isNotEmpty) {
                    await _subirReporte(_detalleController.text, null, latSeleccionada, lngSeleccionada);
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text("Publicar"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// NUEVO: DIÁLOGO PARA VER LA UBICACIÓN MARCADA
class VerMapaDialog extends StatelessWidget {
  final double lat;
  final double lng;
  const VerMapaDialog({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ubicación del Reporte"),
      content: SizedBox(
        height: 350,
        width: 350,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: 16,
          ),
          children: [
            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
      ],
    );
  }
}

// DIÁLOGO PARA SELECCIONAR EL PUNTO EN EL MAPA (Se queda igual)
class SeleccionarMapaDialog extends StatefulWidget {
  const SeleccionarMapaDialog({super.key});
  @override
  State<SeleccionarMapaDialog> createState() => _SeleccionarMapaDialogState();
}

class _SeleccionarMapaDialogState extends State<SeleccionarMapaDialog> {
  LatLng puntoActual = const LatLng(32.5149, -117.0382);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Selecciona el punto"),
      content: SizedBox(
        height: 350,
        width: 350,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: puntoActual,
            initialZoom: 13,
            onTap: (tapPosition, point) => setState(() => puntoActual = point),
          ),
          children: [
            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            MarkerLayer(
              markers: [
                Marker(
                  point: puntoActual,
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {'lat': puntoActual.latitude, 'lng': puntoActual.longitude}),
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}