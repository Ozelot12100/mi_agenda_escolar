import 'package:flutter/material.dart';
import '../services/auth.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const RegisterScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _message = '';
  bool _registrationSuccess = false;
  bool _acceptedTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void _register() async {
    setState(() {
      _message = '';
    });

    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _message = 'Todos los campos son obligatorios.';
      });
      return;
    }

    if (!_acceptedTerms) {
      setState(() {
        _message = 'Debes aceptar los términos y condiciones.';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _message = 'Las contraseñas no coinciden.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _authService.register(
        _usernameController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
        _registrationSuccess = success;
        _message = success
            ? 'Usuario registrado exitosamente.'
            : 'Error al registrar el usuario. El usuario ya existe o hay un problema de conexión.';
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _message = 'Error al registrar el usuario.';
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
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
      containerWidth = size.width * 0.5;
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
            colors: [Colors.purple.shade600, Colors.blue.shade600],
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
              child: _registrationSuccess
                  ? _buildSuccessWidget(context, containerWidth, isMobile)
                  : _buildRegistrationForm(context, containerWidth, isMobile, isDesktop),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessWidget(BuildContext context, double containerWidth, bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            size: 50,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isMobile ? 20 : 30),
        Text(
          'Registro exitoso',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(height: isMobile ? 10 : 15),
        const Text(
          'Tu cuenta ha sido creada correctamente',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: isMobile ? 20 : 30),
        SizedBox(
          width: containerWidth * 0.6,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
                  'Volver al inicio de sesión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(BuildContext context, double containerWidth, bool isMobile, bool isDesktop) {
    return Column(
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
            Icons.person_add,
            size: 40,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isMobile ? 20 : 30),
        Text(
          'Registro de Usuario',
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
          'Crea una cuenta nueva para acceder a la aplicación',
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
              hintText: 'Ingresa un nombre de usuario',
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
              hintText: 'Ingresa una contraseña',
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
            controller: _confirmPasswordController,
            obscureText: !_showConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirmar Contraseña',
              hintText: 'Confirma tu contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _toggleConfirmPasswordVisibility,
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
        SizedBox(height: isMobile ? 15 : 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _acceptedTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptedTerms = value ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Expanded(
                child: Text(
                  'Acepto los términos y condiciones',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 20 : 25),
        if (_message.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _message.contains('exitosamente')
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  _message.contains('exitosamente')
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  color: _message.contains('exitosamente') ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains('exitosamente') ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: isMobile ? 15 : 20),
        _isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
                width: isDesktop ? containerWidth * 0.5 : containerWidth * 0.8,
                child: ElevatedButton(
                  onPressed: _register,
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
                      Icon(Icons.app_registration),
                      SizedBox(width: 10),
                      Text(
                        'Registrarse',
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
              '¿Ya tienes cuenta?',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
