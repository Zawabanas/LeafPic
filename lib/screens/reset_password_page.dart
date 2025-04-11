import 'package:flutter/material.dart';
import 'package:examenfrontomarv/services/auth_services.dart';
import 'package:examenfrontomarv/services/notifications_services.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final String email = args['email'] ?? '';
    final String token = args['token'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Restablecer contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Ingresa tu nueva contraseña:"),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Nueva contraseña"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  cargando
                      ? null
                      : () async {
                        setState(() => cargando = true);
                        final authService = Provider.of<AuthService>(
                          context,
                          listen: false,
                        );
                        final response = await authService.resetPassword(
                          email,
                          token,
                          passwordController.text.trim(),
                        );

                        if (response == null) {
                          NotificationsServices.showSnackbar(
                            "Contraseña actualizada correctamente",
                          );
                          Navigator.pushReplacementNamed(context, 'login');
                        } else {
                          NotificationsServices.showSnackbar(
                            "Error: $response",
                          );
                        }

                        setState(() => cargando = false);
                      },
              child: Text(cargando ? "Procesando..." : "Restablecer"),
            ),
          ],
        ),
      ),
    );
  }
}
