import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = "http://localhost/api";
  
  // Credenciales de prueba (para desarrollo solamente)
  final Map<String, String> _testUsers = {
    'admin': 'admin123',
    'usuario': 'usuario123',
    'estudiante': 'estudiante123',
  };

  Future<bool> register(String username, String password) async {
    // Simulación de registro sin backend
    // En un entorno real, se enviaría la petición al servidor
    await Future.delayed(const Duration(seconds: 1)); // Simular latencia
    
    // Verificamos si el usuario ya existe
    if (_testUsers.containsKey(username)) {
      return false; // Usuario ya existe
    }
    
    // Agregamos el nuevo usuario al mapa de usuarios de prueba
    _testUsers[username] = password;
    return true;
  }

  Future<bool> login(String username, String password) async {
    // Simulación de login sin backend
    // En un entorno real, se enviaría la petición al servidor
    await Future.delayed(const Duration(seconds: 1)); // Simular latencia
    
    // Verificamos si el usuario existe y la contraseña coincide
    return _testUsers.containsKey(username) && _testUsers[username] == password;
    
    /* Código original para cuando se tenga un backend real
    final response = await http.post(
      Uri.parse("$_baseUrl/login.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["success"] == true) {
        return true;
      }
    }
    return false;
    */
  }
}
