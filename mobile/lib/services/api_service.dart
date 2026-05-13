
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:8000";

  // El método ahora recibe el ID, nombre, ubicación y el TOKEN
  Future<bool> crearEstacion(int id, String nombre, String ubicacion, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/estaciones/'),
        headers: {
          'Content-Type': 'application/json',
          // AQUÍ VA EL CÓDIGO DE SEGURIDAD:
          'Authorization': 'Bearer $token', 
        },
        body: jsonEncode({
          'id': id,
          'nombre': nombre,
          'ubicacion': ubicacion,
        }),
      );

      // Si el backend responde 201, se creó con éxito
      return response.statusCode == 201;
    } catch (e) {
      print("Error en ApiService: $e");
      return false;
    }
  }
}