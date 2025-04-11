import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:examenfrontomarv/models/historial_sensor.dart';
import 'package:examenfrontomarv/services/sensor_service.dart';

class SensorHistorialScreen extends StatefulWidget {
  @override
  _SensorHistorialScreenState createState() => _SensorHistorialScreenState();
}

class _SensorHistorialScreenState extends State<SensorHistorialScreen> {
  final SensorService _sensorService = SensorService();
  final storage = FlutterSecureStorage();
  List<HistorialSensor> _historialSensor = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndLoad();
    });
  }

  Future<void> _checkAuthAndLoad() async {
    try {
      await _loadHistorial();
    } catch (e) {
      debugPrint("Error verificando el token: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadHistorial() async {
    try {
      final historial = await _sensorService.getHistorialSensor();
      setState(() {
        _historialSensor = historial;
      });
    } catch (e) {
      debugPrint("Error al cargar historial: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Sensores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Volver al inicio',
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _historialSensor.isEmpty
              ? const Center(
                child: Text('No hay datos de sensores disponibles.'),
              )
              : ListView.builder(
                itemCount: _historialSensor.length,
                itemBuilder: (context, index) {
                  final s = _historialSensor[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.thermostat, color: Colors.blue),
                      title: Text(
                        'Temp: ${s.temperatura}°C, Humedad: ${s.humedad}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Fecha: ${s.fechaRegistro.toLocal()}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
