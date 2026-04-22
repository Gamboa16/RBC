import 'package:flutter/material.dart';
import '../auth_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  String? _municipioSeleccionado;
  String? _zonaSeleccionada;

  // Mapa corregido solo con Tijuana y Ensenada
  final Map<String, List<String>> _datosZonas = {
    "Tijuana": ["Zona Centro", "Otay", "Playas de Tijuana", "La Mesa", "Cerro Colorado"],
    "Ensenada": ["Zona Centro Ensenada", "Maneadero", "El Sauzal", "Valle de Guadalupe"],
  };

  void _registrar() async {
    if (_emailController.text.isNotEmpty && 
        _passController.text.isNotEmpty &&
        _municipioSeleccionado != null && 
        _zonaSeleccionada != null) {
      
      var user = await _authService.registrarUsuario(
        _emailController.text,
        _passController.text,
        _municipioSeleccionado!,
        _zonaSeleccionada!,
      );

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al crear cuenta. Revisa tu conexión.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor llena todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro RBC"),
        backgroundColor: Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController, 
                decoration: const InputDecoration(labelText: "Correo Electrónico", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passController, 
                obscureText: true, 
                decoration: const InputDecoration(labelText: "Contraseña", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              
              // Dropdown de Municipios (Tijuana / Ensenada)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Municipio", border: OutlineInputBorder()),
                hint: const Text("Selecciona Municipio"),
                value: _municipioSeleccionado,
                items: _datosZonas.keys.map((mun) => DropdownMenuItem(value: mun, child: Text(mun))).toList(),
                onChanged: (val) {
                  setState(() {
                    _municipioSeleccionado = val;
                    _zonaSeleccionada = null; 
                  });
                },
              ),
              const SizedBox(height: 15),

              // Dropdown de Zonas dinámicas
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Zona", border: OutlineInputBorder()),
                hint: const Text("Selecciona Zona"),
                value: _zonaSeleccionada,
                items: _municipioSeleccionado == null 
                  ? [] 
                  : _datosZonas[_municipioSeleccionado]!.map((zona) => DropdownMenuItem(value: zona, child: Text(zona))).toList(),
                onChanged: (val) => setState(() => _zonaSeleccionada = val),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registrar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("CREAR CUENTA"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}