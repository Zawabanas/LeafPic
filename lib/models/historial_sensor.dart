class HistorialSensor {
  final double temperatura;
  final double humedad;
  final DateTime fechaRegistro;

  HistorialSensor({
    required this.temperatura,
    required this.humedad,
    required this.fechaRegistro,
  });

  factory HistorialSensor.fromJson(Map<String, dynamic> json) {
    return HistorialSensor(
      temperatura: json['temperatura'].toDouble(),
      humedad: json['humedad'].toDouble(),
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }
}
