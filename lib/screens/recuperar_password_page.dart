import 'package:flutter/material.dart';
import 'package:examenfrontomarv/services/auth_services.dart';
import 'package:examenfrontomarv/services/notifications_services.dart';
import 'package:provider/provider.dart';

class RecuperarPasswordPage extends StatefulWidget {
  const RecuperarPasswordPage({super.key});

  @override
  State<RecuperarPasswordPage> createState() => _RecuperarPasswordPageState();
}

class _RecuperarPasswordPageState extends State<RecuperarPasswordPage> {
  final emailController = TextEditingController();
  bool cargando = false;

  void solicitarRecuperacion() async {
    setState(() => cargando = true);
    final authService = Provider.of<AuthService>(context, listen: false);

    final result = await authService.solicitarRecuperacion(
      emailController.text.trim(),
    );

    if (result == null) {
      NotificationsServices.showSnackbar("Enlace enviado a tu correo");
      Navigator.pop(context); // Regresa al login
    } else {
      NotificationsServices.showSnackbar("Error: $result");
    }

    setState(() => cargando = false);
  }

  void volverAlLogin() {
    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Ingresa tu correo para enviarte el enlace de recuperación.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cargando ? null : solicitarRecuperacion,
              child: Text(cargando ? "Enviando..." : "Enviar"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: volverAlLogin,
              child: const Text(
                "Volver al login",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
