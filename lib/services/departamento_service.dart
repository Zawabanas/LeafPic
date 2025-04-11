import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/departamento.dart';

class DepartamentoService {
  final String baseUrl = 'http://pruebaleafpic.somee.com/api/departamento';

  Future<List<Departamento>> getDepartamentos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Departamento.fromJson(data)).toList();
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }

  Future<void> addDepartamento(Departamento departamento) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(departamento.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al agregar departamento');
    }
  }
}
