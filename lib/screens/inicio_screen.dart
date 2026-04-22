import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BIENVENIDA
            _buildHeader(),
            const SizedBox(height: 25),

            // 2. RETO DEL DÍA
            const Text(
              "🌱 Reto Ecológico de hoy",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRetoCard(
              "¡Cero Goteo!",
              "Revisa que todos los grifos de tu casa estén bien cerrados. Una gota por segundo son 30 litros al día.",
              Icons.opacity, // Icono estándar
              Colors.blue.shade100,
            ),
            const SizedBox(height: 20),

            // 3. GUÍA DE SEPARACIÓN (Nueva sección con más info)
            const Text(
              "♻️ Guía de Separación",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoTile(
              "Orgánicos (Bote Verde)",
              "Restos de comida, cáscaras de fruta y café. ¡Ideales para composta!",
              Icons.eco, 
              Colors.green.shade100,
            ),
            _buildInfoTile(
              "Reciclables (Bote Azul)",
              "Papel, cartón, vidrio y latas de aluminio. Deben estar limpios y secos.",
              Icons.reorder,
              Colors.blue.shade50,
            ),
            _buildInfoTile(
              "No Reciclables (Bote Gris)",
              "Papel higiénico, servilletas usadas, colillas de cigarro y residuos sanitarios.",
              Icons.delete_sweep,
              Colors.grey.shade200,
            ),
            const SizedBox(height: 20),

            // 4. CONSEJOS Y DATOS (Más información agregada)
            const Text(
              "💡 Sabías que...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoTile(
              "Bolsas de Plástico",
              "Una bolsa tarda 400 años en degradarse. ¡Cámbiate a las de tela!",
              Icons.shopping_bag,
              Colors.orange.shade100,
            ),
            _buildInfoTile(
              "Ahorro de Energía",
              "Apagar las luces reduce tu huella de carbono y el costo de tu recibo.",
              Icons.wb_incandescent,
              Colors.yellow.shade100,
            ),
            _buildInfoTile(
              "Pilas y Baterías",
              "Una sola pila de mercurio puede contaminar 600 mil litros de agua. ¡No las tires a la basura!",
              Icons.battery_alert,
              Colors.red.shade100,
            ),
            _buildInfoTile(
              "Desechos Electrónicos",
              "Celulares y cables contienen metales pesados. Llévalos a centros de acopio.",
              Icons.phonelink_erase,
              Colors.blueGrey.shade100,
            ),
            _buildInfoTile(
              "Consumo de Agua",
              "Ducharte en 5 minutos ahorra hasta 100 litros de agua por sesión.",
              Icons.shower,
              Colors.cyan.shade100,
            ),
            _buildInfoTile(
              "Vampiros Eléctricos",
              "Desconecta cargadores que no uses; consumen energía aunque no tengan el móvil conectado.",
              Icons.power_off,
              Colors.deepPurple.shade50,
            ),
            const SizedBox(height: 25),

            // 5. CIERRE MOTIVACIONAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: const [
                  Icon(Icons.auto_awesome, size: 60, color: Colors.green),
                  SizedBox(height: 10),
                  Text(
                    "¡Juntos por una comunidad verde!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Cada pequeña acción cuenta para transformar Baja California.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE APOYO (Sin cambios en estructura) ---

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "¡Hola, Vecino!",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        Text(
          "Bienvenido a tu comunidad RBC.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRetoCard(String titulo, String desc, IconData icono, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icono, size: 40, color: Colors.blue.shade800),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(desc, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String titulo, String desc, IconData icono, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icono, color: Colors.black87),
        ),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }
}