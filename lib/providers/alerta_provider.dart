import 'package:flutter/material.dart';
import '../models/alerta.dart';

class AlertaProvider with ChangeNotifier {
  List<Alerta> _alertas = [];

  List<Alerta> get alertas => _alertas;

  // Simular nueva alerta de humedad
  void simularAlertaHumedad() {
    _alertas.add(
      Alerta(
        tipo: "humedad",
        mensaje: "¡Nivel de humedad crítico! (15%)",
        critica: true,
      ),
    );
    notifyListeners();
    _mostrarNotificacionSimulada(
      "Alerta de Humedad",
      "La humedad ha llegado a niveles críticos",
    );
  }

  // Simular nueva alerta de plaga
  void simularAlertaPlaga() {
    _alertas.add(
      Alerta(
        tipo: "plaga",
        mensaje: "Posible plaga detectada en Sector B",
        critica: false,
      ),
    );
    notifyListeners();
    _mostrarNotificacionSimulada(
      "Alerta de Plaga",
      "Se detectó actividad inusual de insectos",
    );
  }

  void _mostrarNotificacionSimulada(String titulo, String mensaje) {
    // En un caso real, aquí integrarías Firebase Messaging o similar
    debugPrint("NOTIFICACIÓN: $titulo - $mensaje");
  }

  void limpiarAlertas() {
    _alertas.clear();
    notifyListeners();
  }
}
