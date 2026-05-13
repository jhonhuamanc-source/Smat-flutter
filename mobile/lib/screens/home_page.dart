import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _idController = TextEditingController();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();

void _guardarEstacion() async {
  // 1. Obtener los valores de los controladores
  int? id = int.tryParse(_idController.text);
  String nombre = _nombreController.text;
  String ubicacion = _ubicacionController.text;

  if (id != null && nombre.isNotEmpty) {
    // 2. RECUPERAR EL TOKEN (Esto es lo nuevo del Lab 6.2/6.3)
    // Usamos el AuthService para sacar el token de shared_preferences
    String? token = await AuthService().getToken();

    if (token != null) {
      // 3. ENVIAR TODO AL SERVICIO
      bool success = await ApiService().crearEstacion(id, nombre, ubicacion, token);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estación creada en el Backend')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No autorizado o error de servidor')),
        );
      }
    } else {
      // Si no hay token, mandarlo al login (sesión expirada)
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel SMAT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registrar Nueva Estación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'ID de Estación (ej. 1)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre de Estación'),
            ),
            TextField(
              controller: _ubicacionController,
              decoration: const InputDecoration(labelText: 'Ubicación (Lat, Long o Nombre)'),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardarEstacion,
                child: const Text('Guardar en Backend'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}