class Alerta {
  final String tipo; // "humedad" o "plaga"
  final String mensaje;
  final DateTime fecha;
  final bool critica;

  Alerta({
    required this.tipo,
    required this.mensaje,
    required this.critica,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();
}
