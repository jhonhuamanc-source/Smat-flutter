import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://localhost:8000"; // URL para emulador Android 

  Future<bool> login(String username, String password) async {
    // Adaptado para el endpoint /token del backend 
    final response = await http.post(
      Uri.parse('$baseUrl/token'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['access_token'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
    }
    return false;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); 
  }
}