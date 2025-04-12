import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tarea.dart';

class TareasScreen extends StatefulWidget {
  final List<Tarea> tareas;
  final VoidCallback onUpdate;

  const TareasScreen({Key? key, required this.tareas, required this.onUpdate})
    : super(key: key);

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  @override
  Widget build(BuildContext context) {
    List<Tarea> sortedTasks = List.from(widget.tareas)
      ..sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));

    return Scaffold(
      appBar: AppBar(title: const Text("Tareas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            sortedTasks.isEmpty
                ? Center(
                  child: Text(
                    "No hay tareas registradas.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
                : ListView.builder(
                  itemCount: sortedTasks.length,
                  itemBuilder: (context, index) {
                    final tarea = sortedTasks[index];
                    return _buildTareaCard(tarea);
                  },
                ),
      ),
    );
  }

  Widget _buildTareaCard(Tarea tarea) {
    String fechaStr = DateFormat(
      'EEEE, d MMM y • HH:mm',
      'es_ES',
    ).format(tarea.fechaEntrega);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        title: Text(
          tarea.titulo,
          style: TextStyle(
            color:
                tarea.isDone
                    ? Colors.grey
                    : Theme.of(context).textTheme.bodyLarge?.color,
            decoration:
                tarea.isDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tarea.descripcion.isNotEmpty) Text(tarea.descripcion),
            const SizedBox(height: 4),
            Text(
              "Vence: $fechaStr",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              tarea.isDone ? "Estado: Realizada ✅" : "Estado: Pendiente 🕒",
              style: TextStyle(
                color: tarea.isDone ? Colors.greenAccent : Colors.orangeAccent,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              tarea.isDone = !tarea.isDone;
            });
            widget.onUpdate();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  tarea.isDone
                      ? "Tarea marcada como realizada."
                      : "Marca cancelada, tarea pendiente.",
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                tarea.isDone
                    ? Colors.redAccent
                    : Theme.of(context).colorScheme.primary,
          ),
          child: Text(tarea.isDone ? "Desmarcar" : "Realizada"),
        ),
      ),
    );
  }
}
