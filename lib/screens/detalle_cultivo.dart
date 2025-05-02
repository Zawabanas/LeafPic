import 'package:flutter/material.dart';
import 'dart:convert';
import 'principal.dart'; // Importamos el modelo Cultivo

class DetalleCultivoScreen extends StatelessWidget {
  final Cultivo cultivo;

  const DetalleCultivoScreen({Key? key, required this.cultivo})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? imagen;
    if (cultivo.fotoSembradio.isNotEmpty) {
      try {
        final bytes = base64Decode(cultivo.fotoSembradio);
        imagen = MemoryImage(bytes);
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Cultivo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagen != null)
              Center(child: Image(image: imagen, height: 200))
            else
              const Center(child: Text("Sin imagen")),
            const SizedBox(height: 20),
            Text(
              'Tipo de planta: ${cultivo.tipoPlanta}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Extensión: ${cultivo.extensionMts2} m²',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Fecha de registro: ${cultivo.fechaRegistro}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
