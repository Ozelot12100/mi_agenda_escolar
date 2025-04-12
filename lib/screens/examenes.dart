import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/examen.dart';

class ExamenesScreen extends StatefulWidget {
  final List<Examen> examenes;
  final VoidCallback onUpdate;

  const ExamenesScreen({
    Key? key,
    required this.examenes,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ExamenesScreen> createState() => _ExamenesScreenState();
}

class _ExamenesScreenState extends State<ExamenesScreen> {
  @override
  Widget build(BuildContext context) {
    List<Examen> upcomingExams =
        widget.examenes
            .where((examen) => examen.fecha.isAfter(DateTime.now()))
            .toList();
    upcomingExams.sort((a, b) => a.fecha.compareTo(b.fecha));

    return Scaffold(
      appBar: AppBar(title: const Text("Exámenes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            upcomingExams.isEmpty
                ? Center(
                  child: Text(
                    "No hay exámenes programados.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
                : ListView.builder(
                  itemCount: upcomingExams.length,
                  itemBuilder: (context, index) {
                    final examen = upcomingExams[index];
                    String formattedDate = DateFormat(
                      'EEEE, d MMM y • HH:mm',
                      'es_ES',
                    ).format(examen.fecha);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        title: Text(
                          examen.materia,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        subtitle: Text(
                          "Fecha: $formattedDate",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
