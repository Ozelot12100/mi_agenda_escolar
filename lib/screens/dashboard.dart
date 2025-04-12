import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Map<int, List<ActivityHorario>> scheduleData;
  const DashboardScreen({Key? key, required this.scheduleData})
    : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _mostrarGuia = true;

  DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    try {
      if (timeStr.toUpperCase().contains("AM") ||
          timeStr.toUpperCase().contains("PM")) {
        DateTime parsed = DateFormat.jm().parse(timeStr);
        return DateTime(
          now.year,
          now.month,
          now.day,
          parsed.hour,
          parsed.minute,
        );
      } else {
        final parts = timeStr.split(":");
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    } catch (e) {
      return now;
    }
  }

  Color _getChipColor(BuildContext context, String type) {
    if (type == "Examen") {
      return Colors.redAccent;
    } else if (type == "Entrega") {
      return Colors.orangeAccent;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentDayIndex = DateTime.now().weekday - 1;
    if (currentDayIndex < 0) currentDayIndex = 6;
    List<ActivityHorario> todaysActivities =
        widget.scheduleData[currentDayIndex] ?? [];

    todaysActivities.sort(
      (a, b) => _parseTime(a.startTime).compareTo(_parseTime(b.startTime)),
    );

    ActivityHorario? nextActivity;
    DateTime now = DateTime.now();
    for (var activity in todaysActivities) {
      DateTime activityStart = _parseTime(activity.startTime);
      if (activityStart.isAfter(now)) {
        nextActivity = activity;
        break;
      }
    }
    if (nextActivity == null && todaysActivities.isNotEmpty) {
      nextActivity = todaysActivities.first;
    }

    List<ActivityHorario> classes =
        todaysActivities.where((a) => a.type == "Clase").toList();
    List<ActivityHorario> pending =
        todaysActivities
            .where((a) => a.type == "Examen" || a.type == "Entrega")
            .toList();

    String formattedDate = DateFormat(
      'EEEE, d MMMM y',
      'es_ES',
    ).format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "¡Hola, Usuario! 👋",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(formattedDate, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),

          if (_mostrarGuia)
            Card(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Guía rápida 🚀",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.calendar_today, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Agrega actividades como Tareas o Exámenes en Horario.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.menu_book, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Agrega Materias en el apartado de Materias.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.check_circle_outline, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Consulta Tareas y Exámenes en sus respectivos apartados.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _mostrarGuia = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Text(
            "Siguiente Actividad",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Theme.of(context).colorScheme.surface,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child:
                  nextActivity != null
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  nextActivity.title,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  nextActivity.type,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: _getChipColor(
                                  context,
                                  nextActivity.type,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${nextActivity.startTime} - ${nextActivity.endTime}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${nextActivity.location} | ${nextActivity.professor}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                      : Center(
                        child: Text(
                          "No hay actividad programada",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 16),

          Text("Clases de Hoy", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          classes.isNotEmpty
              ? Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).colorScheme.surface,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children:
                        classes.map((activity) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  activity.startTime,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    activity.title,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    activity.type,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: _getChipColor(
                                    context,
                                    activity.type,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              )
              : Center(
                child: Text(
                  "No tienes clases programadas para hoy.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          const SizedBox(height: 16),

          Text(
            "Pendientes de Hoy",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          pending.isNotEmpty
              ? Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(context).colorScheme.surface,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children:
                        pending.map((activity) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  activity.startTime,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    activity.title,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    activity.type,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: _getChipColor(
                                    context,
                                    activity.type,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              )
              : Center(
                child: Text(
                  "No tienes exámenes ni entregas para hoy.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
        ],
      ),
    );
  }
}
