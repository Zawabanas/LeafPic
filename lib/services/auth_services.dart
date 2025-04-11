import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:examenfrontomarv/models/AuthResponse.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'http://SIMAOMEGA.somee.com';
  final storage = const FlutterSecureStorage();

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'ConfirmPassword': password,
    };
    final url = Uri.parse('$_baseUrl/api/Cuentas/Login');

    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json", // Corregido
        "accept": "application/json",
      },
      body: json.encode(authData),
    );

    print('Response status: ${resp.statusCode}');
    print('Response body: ${resp.body}');

    if (resp.statusCode == 200) {
      final decodeResp = AuthResponse.fromJson(json.decode(resp.body));
      if (decodeResp.token != null) {
        await storage.write(key: "token", value: decodeResp.token);
        return null;
      } else {
        return decodeResp.error ?? 'Token no encontrado';
      }
    } else {
      try {
        final Map<String, dynamic> respBody = json.decode(resp.body);
        return respBody['error'] ?? 'Credenciales inválidas';
      } catch (e) {
        print('Error al parsear respuesta de error: $e');
        return 'Error desconocido';
      }
    }
  }

  Future<String?> createUser(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'Password': password,
      'ConfirmPassword': confirmPassword,
    };

    final url = Uri.parse('$_baseUrl/api/Cuentas/registrar');

    final resp = await http.post(
      url,
      headers: {
        "Content-Type": "application/json", // Corregido
        "accept": "application/json",
      },
      body: json.encode(authData),
    );

    print('Response body: ${resp.body}');

    try {
      final decodeResp = AuthResponse.fromJson(json.decode(resp.body));
      if (decodeResp.token != null) {
        await storage.write(key: 'token', value: decodeResp.token);
        return null;
      } else {
        return decodeResp.error ?? 'Error desconocido al registrar';
      }
    } catch (e) {
      print('Error al decodificar la respuesta: $e');
      return 'Error en la respuesta del servidor';
    }
  }

  Future<String> readToken() async {
    return await storage.read(key: "token") ?? '';
  }

  Future logout() async {
    await storage.delete(key: "token");
  }

  Future<String?> solicitarRecuperacion(String email) async {
    final url = Uri.parse('$_baseUrl/api/Cuentas/olvide-password');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json-patch+json",
        "accept": "application/json",
      },
      body: json.encode({
        'email': email,
        'urlRedireccion': 'tuapp://reset-password',
      }),
    );

    print('Recuperar: ${response.body}');

    if (response.statusCode == 200) return null;
    final Map<String, dynamic> respBody = jsonDecode(response.body);
    return respBody['error'] ?? 'Error desconocido';
  }

  Future<String?> resetPassword(
    String email,
    String token,
    String nuevaPassword,
  ) async {
    final url = Uri.parse('$_baseUrl/api/Cuentas/reset-password');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json-patch+json",
        "accept": "application/json",
      },
      body: json.encode({
        'email': email,
        'token': token,
        'nuevaPassword': nuevaPassword,
      }),
    );

    print('Reset: ${response.body}');

    if (response.statusCode == 200) return null;
    final Map<String, dynamic> respBody = jsonDecode(response.body);
    return respBody['error'] ?? 'Error desconocido';
  }
}
