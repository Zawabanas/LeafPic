import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  late AnimationController _animationController;
  late Animation<double> _animateIcon;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;
  List<Cultivo> _cultivos = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animateIcon = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _cargarCultivos();
  }

  Future<void> _cargarCultivos() async {
    final url = Uri.parse('http://SIMAOMEGA.somee.com/api/sembradios');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _cultivos = data.map((e) => Cultivo.fromJson(e)).toList();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al cargar cultivos')));
    }
  }

  Future<void> _eliminarCultivo(int id) async {
    final url = Uri.parse('http://SIMAOMEGA.somee.com/api/sembradios/$id');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cultivo eliminado')));
      _cargarCultivos();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar cultivo')),
      );
    }
  }

  String _generarRecomendaciones(String tipoPlanta) {
    return '''
Recomendaciones para $tipoPlanta:

1. Aplicar 100 kg/ha de fertilizante NPK 15-15-15
2. Realizar 2 aplicaciones foliares de micronutrientes
3. Mantener pH del suelo entre 6.0 y 6.5
4. Aplicar materia orgánica cada 3 meses
''';
  }

  void _mostrarDetalle(Cultivo cultivo) {
    final recomendaciones = _generarRecomendaciones(cultivo.tipoPlanta);
    showDialog(
      context: context,
      builder: (context) {
        ImageProvider? imagen;
        if (cultivo.fotoSembradio.isNotEmpty) {
          try {
            final bytes = base64Decode(cultivo.fotoSembradio);
            imagen = MemoryImage(bytes);
          } catch (_) {}
        }

        return AlertDialog(
          title: const Text('Detalle del Cultivo'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagen != null)
                  Center(child: Image(image: imagen, height: 150))
                else
                  const Text('Sin imagen'),
                const SizedBox(height: 10),
                Text('Tipo de planta: ${cultivo.tipoPlanta}'),
                Text('Hectáreas: ${cultivo.extensionMts2} m²'),
                Text('Fecha: ${cultivo.fechaRegistro}'),
                const SizedBox(height: 20),
                const Text(
                  'Recomendaciones de Fertilización',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    recomendaciones,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _eliminarCultivo(cultivo.id);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Inicio',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ya estás en la pantalla de inicio.'),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text("SIMA"),
              accountEmail: const Text("OMEGA"),
              decoration: BoxDecoration(color: Colors.grey[900]),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('Historial de Sensores'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'sensorHistorial');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Agregar Cultivo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'agregarCultivo').then((value) {
                  if (value == true) {
                    _cargarCultivos();
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.orange,
              ),
              title: const Text('Alertas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'alertas');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                await storage.delete(key: 'token');
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
      body:
          _cultivos.isEmpty
              ? const Center(child: Text('No hay cultivos registrados'))
              : ListView.builder(
                itemCount: _cultivos.length,
                itemBuilder: (context, index) {
                  final cultivo = _cultivos[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: const Icon(Icons.grass),
                      title: Text(cultivo.tipoPlanta),
                      subtitle: Text(
                        '${cultivo.extensionMts2} m²\n${cultivo.fechaRegistro}',
                      ),
                      onTap: () => _mostrarDetalle(cultivo),
                    ),
                  );
                },
              ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (_isExpanded) ...[
            ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: FloatingActionButton.extended(
                  heroTag: 'alertas',
                  onPressed: () {
                    Navigator.pushNamed(context, 'alertas');
                    _toggle();
                  },
                  icon: const Icon(Icons.warning, color: Colors.white),
                  label: const Text(
                    'Ver Alertas',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: FloatingActionButton.extended(
                  heroTag: 'agregarCultivo',
                  onPressed: () {
                    Navigator.pushNamed(context, 'agregarCultivo').then((
                      value,
                    ) {
                      if (value == true) {
                        _cargarCultivos();
                      }
                    });
                    _toggle();
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Agregar Cultivo',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
          FloatingActionButton(
            heroTag: 'mainFab',
            onPressed: _toggle,
            tooltip: 'Opciones',
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animateIcon,
            ),
          ),
        ],
      ),
    );
  }
}
