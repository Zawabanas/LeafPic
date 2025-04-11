import 'package:examenfrontomarv/providers/alerta_provider.dart';
import 'package:examenfrontomarv/screens/Agregar.dart';
import 'package:examenfrontomarv/screens/alerta_screen.dart';
import 'package:examenfrontomarv/screens/recomendaciones.dart';
import 'package:examenfrontomarv/screens/recuperar_password_page.dart';
import 'package:examenfrontomarv/screens/reset_password_page.dart';
import 'package:examenfrontomarv/screens/sensor_screen.dart';
import 'package:flutter/material.dart';
import 'package:examenfrontomarv/services/auth_services.dart';
import 'package:examenfrontomarv/services/notifications_services.dart';
import 'package:examenfrontomarv/screens/checking.dart';
import 'package:examenfrontomarv/screens/login.dart';
import 'package:examenfrontomarv/screens/principal.dart';
import 'package:examenfrontomarv/screens/registro.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => AlertaProvider()),
      ],
      // Asegúrate de agregar esto
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Examen Departamentos OmarV',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 247, 230, 196),
        ),
        useMaterial3: true,
      ),
      initialRoute: 'checking',
      routes: {
        'login': (_) => const LoginPage(),
        'register': (_) => const RegistroPage(),
        'home': (_) => HomeScreen(),
        'checking': (_) => const CheckAuthScreen(),
        'sensorHistorial': (_) => SensorHistorialScreen(),
        'agregarCultivo': (_) => AgregarCultivoScreen(),
        'recuperar': (_) => const RecuperarPasswordPage(),
        'restablecer': (_) => const ResetPasswordPage(),
        'recomendaciones': (_) => const FertilizacionPage(),
        'alertas': (_) => AlertasScreen(),
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
    );
  }
}
