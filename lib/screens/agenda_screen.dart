import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // LÓGICA SIMPLIFICADA: 
    // Usamos el día del mes para decidir si es semana activa (puedes ajustarlo después)
    DateTime hoy = DateTime.now();
    bool esSemanaActiva = hoy.day <= 15; // Ejemplo: activa la primera quincena

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Calendario Comunitario",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const Text("Próximas jornadas en tu colonia"),
          const SizedBox(height: 20),
          
          // Indicador de estado
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: esSemanaActiva ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: esSemanaActiva ? Colors.green : Colors.orange),
            ),
            child: Row(
              children: [
                Icon(esSemanaActiva ? Icons.check_circle : Icons.pause_circle, 
                     color: esSemanaActiva ? Colors.green : Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    esSemanaActiva 
                      ? "¡Esta semana hay recolección activa!" 
                      : "Semana de descanso. Próxima fecha: Viernes",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tarjeta de Viernes
          _buildTarjetaEvento(context, "Viernes: Preparación", "06:00 PM", Icons.inventory_2),
          // Tarjeta de Sábado
          _buildTarjetaEvento(context, "Sábado: Recolección", "08:00 AM", Icons.local_shipping),
          // Tarjeta de Domingo
          _buildTarjetaEvento(context, "Domingo: Limpieza", "10:00 AM", Icons.park),
        ],
      ),
    );
  }

  Widget _buildTarjetaEvento(BuildContext context, String titulo, String hora, IconData icono) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icono, color: Colors.green, size: 40),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Hora: $hora\nPunto: Parque Principal"),
        trailing: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("¡Asistencia registrada!")),
            );
          },
          child: const Text("Asistir"),
        ),
      ),
    );
  }
}