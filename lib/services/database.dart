import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseService {
  final String _baseUrl = "http://localhost/api";

  Future<List<dynamic>> getMaterias() async {
    final response = await http.get(Uri.parse("$_baseUrl/materias"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al cargar las materias");
    }
  }

  Future<List<dynamic>> getTareas() async {
    final response = await http.get(Uri.parse("$_baseUrl/tareas"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al cargar las tareas");
    }
  }
}
