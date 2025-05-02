import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgregarCultivoScreen extends StatefulWidget {
  @override
  _AgregarCultivoScreenState createState() => _AgregarCultivoScreenState();
}

class _AgregarCultivoScreenState extends State<AgregarCultivoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _hectareasController = TextEditingController();

  File? _imagen;
  final picker = ImagePicker();

  Future<void> _seleccionarImagen() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imagen = File(pickedFile.path);
      }
    });
  }

  Future<void> _tomarFoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imagen = File(pickedFile.path);
      }
    });
  }

  Future<void> _guardarCultivo() async {
    final url = Uri.parse('http://SIMAOMEGA.somee.com/api/sembradios');

    String fotoBase64 = '';
    if (_imagen != null) {
      final bytes = await _imagen!.readAsBytes();
      fotoBase64 = base64Encode(bytes);
    }

    final cultivo = {
      'tipoPlanta': _tipoController.text,
      'extensionMts2': double.tryParse(_hectareasController.text) ?? 0,
      'fotoSembradio': fotoBase64,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cultivo),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true); // Para que Principal.dart recargue
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cultivo agregado')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al agregar cultivo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Cultivo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo de cultivo'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _hectareasController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de hectáreas',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              _imagen != null
                  ? Image.file(_imagen!)
                  : const Text('No hay imagen seleccionada'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _seleccionarImagen,
                    icon: const Icon(Icons.photo),
                    label: const Text('Galería'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _tomarFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarCultivo();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
