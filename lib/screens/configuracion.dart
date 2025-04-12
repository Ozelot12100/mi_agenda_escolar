import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  
  const ConfiguracionScreen({super.key, this.onLogout});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  String selectedTextSize = 'Normal';
  bool notificationsEnabled = true;
  bool silenceNotifications = false;


  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Apariencia",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tema oscuro:"),
                        Row(
                          children: [
                            Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: isDark ? Colors.yellow : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isDark ? "Activado" : "Desactivado",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tamaño del texto:"),
                        DropdownButton<String>(
                          value: selectedTextSize,
                          items: const [
                            DropdownMenuItem(
                              value: "Pequeño",
                              child: Text("Pequeño"),
                            ),
                            DropdownMenuItem(
                              value: "Normal",
                              child: Text("Normal"),
                            ),
                            DropdownMenuItem(
                              value: "Grande",
                              child: Text("Grande"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedTextSize = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "*(solo afecta esta pantalla, visual en desarrollo)*",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Notificaciones",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Notificaciones de tareas:"),
                        Row(
                          children: [
                            Icon(
                              notificationsEnabled ? Icons.check : Icons.close,
                              color:
                                  notificationsEnabled
                                      ? Colors.green
                                      : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              notificationsEnabled
                                  ? "Activadas"
                                  : "Desactivadas",
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Silenciar por horario:"),
                        Row(
                          children: [
                            Icon(
                              silenceNotifications ? Icons.check : Icons.close,
                              color:
                                  silenceNotifications
                                      ? Colors.green
                                      : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              silenceNotifications ? "Activado" : "Desactivado",
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "*(sin implementación real aún)*",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Gestión de datos",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Función en desarrollo..."),
                          ),
                        );
                      },
                      child: const Text("Exportar datos 📦"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Función en desarrollo..."),
                          ),
                        );
                      },
                      child: const Text("Importar datos 📥"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Función en desarrollo..."),
                          ),
                        );
                      },
                      child: const Text("Reiniciar app 🗑️"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sección de cierre de sesión
            Text(
              "Sesión",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text("Cerrar sesión"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Cerrar sesión'),
                              content: const Text('¿Estás seguro de que deseas cerrar la sesión?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Cierra el diálogo
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Cierra el diálogo
                                    if (widget.onLogout != null) {
                                      widget.onLogout!();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Cerrar sesión'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Información",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Versión: 1.0.0"),
                    SizedBox(height: 4),
                    Text("Desarrolladores: David - Airam"),
                    SizedBox(height: 4),
                    Text("Contacto: queti@gmail.com"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
