class Departamento {
  final int id;
  final String nombre;
  final String descripcion; // Nuevo campo

  Departamento({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion:
          json['descripcion'], // Asegúrate de que esto coincida con el backend
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion, // Asegúrate de enviar este campo
    };
  }
}
