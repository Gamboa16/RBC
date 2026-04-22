import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'screens/registro_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/agenda_screen.dart';
import 'screens/reportes_screen.dart';
import 'screens/actividades_screen.dart';
import'package:rbc_app/screens/perfil_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyAppRBC());
}

class MyAppRBC extends StatelessWidget {
  const MyAppRBC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RBC Comunidad',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true),
      // Ruta inicial: Registro
      home: const RegistroScreen(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final List<Widget> _pantallas = [
    const InicioScreen(),
    const AgendaScreen(),
    const ActividadesScreen(),
    const ReportesScreen(),
    const PerfilScreen(), // <-- Cambia el Center que tenías por esto
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RBC Comunidad"), backgroundColor: Colors.green.shade100),
      body: _pantallas[_index], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (val) => setState(() => _index = val),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Agenda"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Actividades"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Reportes"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}