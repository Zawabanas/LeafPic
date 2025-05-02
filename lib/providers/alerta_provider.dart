import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/alerta.dart';

class AlertaProvider with ChangeNotifier {
  final List<Alerta> _alertas = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AlertaProvider() {
    _initNotifications();
  }

  List<Alerta> get alertas => _alertas;

  void _initNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void agregarAlerta({
    required String tipo,
    required String mensaje,
    required bool critica,
  }) {
    // Evita alertas duplicadas con el mismo tipo y mensaje
    if (_alertas.any((a) => a.tipo == tipo && a.mensaje == mensaje)) return;

    final nuevaAlerta = Alerta(tipo: tipo, mensaje: mensaje, critica: critica);
    _alertas.add(nuevaAlerta);
    notifyListeners();

    _mostrarNotificacionLocal("Alerta de $tipo", mensaje);
  }

  void _mostrarNotificacionLocal(String titulo, String mensaje) async {
    const androidDetails = AndroidNotificationDetails(
      'alertas_channel',
      'Alertas Críticas',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(
      0,
      titulo,
      mensaje,
      notificationDetails,
    );
  }

  void limpiarAlertas() {
    _alertas.clear();
    notifyListeners();
  }
}
