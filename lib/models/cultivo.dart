class Cultivo {
  final int id;
  final String tipoPlanta;
  final double extensionMts2;
  final String fotoSembradio;
  final String fechaRegistro;

  Cultivo({
    required this.id,
    required this.tipoPlanta,
    required this.extensionMts2,
    required this.fotoSembradio,
    required this.fechaRegistro,
  });

  factory Cultivo.fromJson(Map<String, dynamic> json) {
    return Cultivo(
      id: json['id'],
      tipoPlanta: json['tipoPlanta'],
      extensionMts2: (json['extensionMts2'] as num).toDouble(),
      fotoSembradio: json['fotoSembradio'],
      fechaRegistro: json['fechaRegistro'],
    );
  }
}
