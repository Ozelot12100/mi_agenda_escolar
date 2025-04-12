import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback onLoginSuccess;
  
  const LoginScreen({
    Key? key, 
    required this.toggleTheme,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _showPassword = false;

  void _login() async {
    setState(() {
      _errorMessage = '';
    });

    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa usuario y contraseña.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        widget.onLoginSuccess();
      } else {
        setState(() {
          _errorMessage = 'Credenciales inválidas.';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al iniciar sesión.';
      });
    }
  }

  void _forgotPassword() {
    // Función de recuperación de contraseña (placeholder).
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de recuperación no implementada.')),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;
    final bool isTablet = size.width >= 600 && size.width < 1200;
    final bool isDesktop = size.width >= 1200;
    
    double containerWidth = size.width;
    if (isTablet) {
      containerWidth = size.width * 0.7;
    } else if (isDesktop) {
      containerWidth = size.width * 0.4;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.purple.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 0,
                vertical: 30,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 30),
                  Text(
                    'Iniciar Sesión',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  SizedBox(height: isMobile ? 10 : 15),
                  Text(
                    'Accede a tu cuenta para gestionar tu agenda escolar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                  SizedBox(height: isMobile ? 25 : 35),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        hintText: 'Ingresa tu nombre de usuario',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 15 : 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _forgotPassword,
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: isMobile ? 20 : 25),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: isDesktop ? containerWidth * 0.5 : containerWidth * 0.8,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40, 
                                vertical: isMobile ? 15 : 20,
                              ),
                              elevation: 5,
                              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login),
                                SizedBox(width: 10),
                                Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(height: isMobile ? 15 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RegisterScreen(toggleTheme: widget.toggleTheme),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
