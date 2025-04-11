import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/historial_sensor.dart';

class SensorService {
  final _baseUrl = 'http://SIMAOMEGA.somee.com';
  final _storage = FlutterSecureStorage();

  Future<List<HistorialSensor>> getHistorialSensor() async {
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('$_baseUrl/api/sensores/historial');

    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return data.map((e) => HistorialSensor.fromJson(e)).toList();
    } else if (resp.statusCode == 401) {
      throw Exception('Token inválido o expirado');
    } else {
      throw Exception('Error al obtener datos del sensor');
    }
  }
}
