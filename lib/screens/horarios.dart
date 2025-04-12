import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../models/materia.dart';
import '../models/tarea.dart';
import '../models/examen.dart';

class HorarioScreen extends StatefulWidget {
  final Map<int, List<ActivityHorario>> scheduleData;
  final VoidCallback onUpdate;
  final List<Materia> materias;
  final List<Tarea> tareas;
  final List<Examen> examenes;

  const HorarioScreen({
    Key? key,
    required this.scheduleData,
    required this.onUpdate,
    required this.materias,
    required this.tareas,
    required this.examenes,
  }) : super(key: key);

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  final List<String> _days = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
  late int _selectedDayIndex;

  @override
  void initState() {
    super.initState();
    _selectedDayIndex = DateTime.now().weekday - 1;
    if (_selectedDayIndex < 0) _selectedDayIndex = 6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Horario Semanal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedDayIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _days[index],
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  widget.scheduleData[_selectedDayIndex]?.isNotEmpty ?? false
                      ? ListView.builder(
                        itemCount:
                            widget.scheduleData[_selectedDayIndex]?.length ?? 0,
                        itemBuilder: (context, index) {
                          final activity =
                              widget.scheduleData[_selectedDayIndex]![index];
                          Color chipColor;
                          if (activity.type == "Examen") {
                            chipColor = Colors.redAccent;
                          } else if (activity.type == "Entrega") {
                            chipColor = Colors.orangeAccent;
                          } else {
                            chipColor = Theme.of(context).colorScheme.primary;
                          }
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${activity.startTime} - ${activity.endTime}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          activity.title,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.headlineSmall,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(
                                          activity.type,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: chipColor,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${activity.location} | ${activity.professor}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Text(
                          "No hay actividades para este día.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddActivityDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddActivityDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? selectedMateria;
    final TextEditingController otroTituloController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController professorController = TextEditingController();
    String selectedType = "Examen";
    int selectedDayIndex = _selectedDayIndex;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                "Agregar nueva actividad",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedMateria,
                        decoration: const InputDecoration(labelText: "Materia"),
                        items: [
                          ...widget.materias.map(
                            (materia) => DropdownMenuItem(
                              value: materia.nombre,
                              child: Text(materia.nombre),
                            ),
                          ),
                          const DropdownMenuItem(
                            value: "Otro",
                            child: Text("Otro"),
                          ),
                        ],
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedMateria = value;
                            if (value != "Otro") {
                              final materia = widget.materias.firstWhere(
                                (m) => m.nombre == value,
                                orElse:
                                    () => Materia(nombre: "", diasSemana: []),
                              );
                              locationController.text = materia.aula;
                              professorController.text = materia.profesor;
                            } else {
                              locationController.text = "";
                              professorController.text = "";
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Selecciona una materia o 'Otro'";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      if (selectedMateria == "Otro")
                        TextFormField(
                          controller: otroTituloController,
                          decoration: const InputDecoration(
                            labelText: "Nombre de actividad",
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Este campo es obligatorio";
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: "Tipo de actividad",
                        ),
                        items:
                            <String>["Examen", "Entrega"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newVal) {
                          setStateDialog(() {
                            selectedType = newVal!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedDayIndex,
                        decoration: const InputDecoration(
                          labelText: "Día de la semana",
                        ),
                        items: List.generate(_days.length, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(_days[index]),
                          );
                        }),
                        onChanged: (int? newVal) {
                          setStateDialog(() {
                            selectedDayIndex = newVal!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setStateDialog(() {
                                    startTime = picked;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: "Hora inicio",
                                ),
                                child: Text(
                                  startTime == null
                                      ? "Seleccionar"
                                      : startTime!.format(context),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setStateDialog(() {
                                    endTime = picked;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: "Hora fin",
                                ),
                                child: Text(
                                  endTime == null
                                      ? "Seleccionar"
                                      : endTime!.format(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: "Aula",
                          hintText: "Ej. Aula A102",
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: professorController,
                        decoration: const InputDecoration(
                          labelText: "Profesor",
                          hintText: "Ej. Prof. Juan Martínez",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        startTime != null &&
                        endTime != null) {
                      String finalTitle =
                          (selectedMateria == "Otro")
                              ? otroTituloController.text.trim()
                              : selectedMateria!;
                      ActivityHorario newActivity = ActivityHorario(
                        title: finalTitle,
                        type: selectedType,
                        startTime: startTime!.format(context),
                        endTime: endTime!.format(context),
                        location: locationController.text.trim(),
                        professor: professorController.text.trim(),
                      );
                      setState(() {
                        widget.scheduleData[selectedDayIndex]?.add(newActivity);
                      });
                      if (selectedType == "Entrega") {
                        final DateTime tareaDateTime =
                            _calculateDateTimeForTask(
                              selectedDayIndex,
                              endTime!,
                            );
                        final newTask = Tarea(
                          id: DateTime.now().millisecondsSinceEpoch,
                          titulo: finalTitle,
                          descripcion: "Tarea generada automáticamente",
                          fechaEntrega: tareaDateTime,
                          isDone: false,
                        );
                        widget.tareas.add(newTask);
                      }
                      if (selectedType == "Examen") {
                        final DateTime examDateTime = _calculateDateTimeForExam(
                          selectedDayIndex,
                          endTime!,
                        );
                        final newExam = Examen(
                          id: DateTime.now().millisecondsSinceEpoch,
                          materia: finalTitle,
                          fecha: examDateTime,
                        );
                        widget.examenes.add(newExam);
                      }
                      Navigator.pop(context);
                      widget.onUpdate();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Actividad agregada correctamente."),
                        ),
                      );
                    } else {
                      if (startTime == null || endTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Por favor, selecciona la hora de inicio y fin.",
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Agregar ✔️"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  DateTime _calculateDateTimeForTask(int dayIndex, TimeOfDay timeOfDay) {
    final now = DateTime.now();
    int currentDay = now.weekday - 1;
    if (currentDay < 0) currentDay = 6;
    int diff = dayIndex - currentDay;
    if (diff < 0) diff += 7;
    final DateTime baseDate = now.add(Duration(days: diff));
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  DateTime _calculateDateTimeForExam(int dayIndex, TimeOfDay timeOfDay) {
    final now = DateTime.now();
    int currentDay = now.weekday - 1;
    if (currentDay < 0) currentDay = 6;
    int diff = dayIndex - currentDay;
    if (diff < 0) diff += 7;
    final DateTime baseDate = now.add(Duration(days: diff));
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }
}
