import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'utils/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = true; // Tema oscuro por defecto
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Escolar',
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme ? buildDarkTheme() : buildLightTheme(),
      // Ahora usamos el LoginScreen como pantalla inicial
      home: isLoggedIn 
          ? HomeScreen(
              toggleTheme: _toggleTheme,
              onLogout: _handleLogout,
            )
          : LoginScreen(
              toggleTheme: _toggleTheme,
              onLoginSuccess: _handleLoginSuccess,
            ),
    );
  }

  // Función que alterna entre tema claro y oscuro
  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  // Manejador para el inicio de sesión exitoso
  void _handleLoginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  // Manejador para el cierre de sesión
  void _handleLogout() {
    setState(() {
      isLoggedIn = false;
    });
  }
}
