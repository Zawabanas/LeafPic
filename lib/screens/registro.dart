import 'package:flutter/material.dart';
import 'package:examenfrontomarv/services/auth_services.dart';
import 'package:examenfrontomarv/providers/register_provider.dart';
import 'package:examenfrontomarv/services/notifications_services.dart';
import 'package:examenfrontomarv/ui/input_decoration.dart';
import 'package:examenfrontomarv/widgets/card_container.dart';
import 'package:provider/provider.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // gradiente de fondo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightGreenAccent, // Color azul oscuro
                  Colors.green, // Color azul claro
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Contenido del registro
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 250),
                CardContainer(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Crear cuenta',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 30),
                      ChangeNotifierProvider(
                        create: (_) => RegisterProvider(),
                        child: _RegisterForm(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed:
                      () => Navigator.pushReplacementNamed(context, 'login'),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Colors.redAccent.withOpacity(0.1),
                    ),
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                  ),
                  child: const Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterProvider>(context);

    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Ejemplo@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => registerForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Confirmar Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => registerForm.confirmPassword = value,
              validator: (value) {
                return (value != null && value == registerForm.password)
                    ? null
                    : 'Las contraseñas no coinciden';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.black,
              onPressed:
                  registerForm.isLoading
                      ? null
                      : () async {
                        FocusScope.of(context).unfocus();
                        final authService = Provider.of<AuthService>(
                          context,
                          listen: false,
                        );

                        if (!registerForm.isValidForm2()) return;

                        registerForm.isLoading = true;

                        final String? errorMessage = await authService
                            .createUser(
                              registerForm.email,
                              registerForm.password,
                              registerForm.confirmPassword,
                            );

                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'login');
                        } else {
                          NotificationsServices.showSnackbar(errorMessage);
                          registerForm.isLoading = false;
                        }
                      },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 15,
                ),
                child: Text(
                  registerForm.isLoading ? 'Espere' : 'Crear',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
