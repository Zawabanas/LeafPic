import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FertilizacionPage extends StatefulWidget {
  const FertilizacionPage({super.key});

  @override
  State<FertilizacionPage> createState() => _FertilizacionPageState();
}

class _FertilizacionPageState extends State<FertilizacionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cultivoController = TextEditingController();
  XFile? _imagenCultivo;
  String _recomendaciones =
      "Aquí aparecerán las recomendaciones de fertilización generadas por la IA";

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        _imagenCultivo = imagen;
        // Simulamos que al subir la imagen la IA genera recomendaciones
        _recomendaciones =
            "Recomendaciones para ${_cultivoController.text}:\n\n"
            "1. Aplicar 100 kg/ha de fertilizante NPK 15-15-15\n"
            "2. Realizar 2 aplicaciones foliares de micronutrientes\n"
            "3. Mantener pH del suelo entre 6.0 y 6.5\n"
            "4. Aplicar materia orgánica cada 3 meses";
      });
    }
  }

  Future<void> _generarRecomendaciones() async {
    if (_cultivoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese el tipo de cultivo')),
      );
      return;
    }

    // Simulamos el procesamiento de la IA
    setState(() {
      _recomendaciones = "Analizando...";
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _recomendaciones =
          "Recomendaciones para ${_cultivoController.text}:\n\n"
          "1. Aplicar 100 kg/ha de fertilizante NPK 15-15-15\n"
          "2. Realizar 2 aplicaciones foliares de micronutrientes\n"
          "3. Mantener pH del suelo entre 6.0 y 6.5\n"
          "4. Aplicar materia orgánica cada 3 meses";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendaciones de Fertilización'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo para el cultivo
                TextFormField(
                  controller: _cultivoController,
                  decoration: InputDecoration(
                    hintText: 'Ej. Maíz, Tomate, etc.',
                    labelText: 'Tipo de Cultivo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tipo de cultivo';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Botón para generar recomendaciones
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.lightGreen,
                  onPressed: _generarRecomendaciones,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Generar Recomendaciones',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Sección para la imagen
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const Text(
                          'Imagen del Cultivo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _seleccionarImagen,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                _imagenCultivo == null
                                    ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        Text('Toca para agregar una imagen'),
                                      ],
                                    )
                                    : Image.network(
                                      _imagenCultivo!.path,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Campo para recomendaciones (solo lectura)
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recomendaciones de Fertilización',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _recomendaciones,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cultivoController.dispose();
    super.dispose();
  }
}
