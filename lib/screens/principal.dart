import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
              accountName: const Text("Examen"),
              accountEmail: const Text("Front"),
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
                Navigator.pushNamed(context, 'agregarCultivo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.recommend),
              title: const Text('Recomendaciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'recomendaciones');
              },
            ),
            // NUEVO ITEM PARA ALERTAS EN EL DRAWER
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
      body: const Center(
        child: Text(
          '¡Bienvenido!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (_isExpanded) ...[
            // NUEVO BOTÓN PARA ALERTAS
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
                  heroTag: 'recomendaciones',
                  onPressed: () {
                    Navigator.pushNamed(context, 'recomendaciones');
                    _toggle();
                  },
                  icon: const Icon(Icons.recommend, color: Colors.white),
                  label: const Text(
                    'Recomendaciones',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
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
                    Navigator.pushNamed(context, 'agregarCultivo');
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
