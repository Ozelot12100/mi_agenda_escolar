import 'package:flutter/material.dart';
import '../models/materia.dart';

class MateriasScreen extends StatefulWidget {
  final List<Materia> materias;
  final VoidCallback onUpdate;
  final Function(Materia) onMateriaAdded;
  const MateriasScreen({
    Key? key,
    required this.materias,
    required this.onUpdate,
    required this.onMateriaAdded,
  }) : super(key: key);

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Materias")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            widget.materias.isEmpty
                ? Center(
                  child: Text(
                    "No hay materias registradas.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
                : ListView.builder(
                  itemCount: widget.materias.length,
                  itemBuilder: (context, index) {
                    final materia = widget.materias[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          materia.nombre,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (materia.profesor.isNotEmpty)
                              Text("Profesor: ${materia.profesor}"),
                            if (materia.aula.isNotEmpty)
                              Text("Aula: ${materia.aula}"),
                            if (materia.diasSemana.isNotEmpty)
                              Text("Días: ${materia.diasSemana.join(", ")}"),
                            if (materia.horaInicio.isNotEmpty ||
                                materia.horaFin.isNotEmpty)
                              Text(
                                "Horario: ${materia.horaInicio} - ${materia.horaFin}",
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              widget.materias.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Materia eliminada."),
                              ),
                            );
                            widget.onUpdate();
                          },
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMateriaDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMateriaDialog() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nombreCtrl = TextEditingController();
    final TextEditingController profesorCtrl = TextEditingController();
    final TextEditingController aulaCtrl = TextEditingController();

    final List<String> diasDisponibles = [
      "Lun",
      "Mar",
      "Mié",
      "Jue",
      "Vie",
      "Sáb",
      "Dom",
    ];
    final List<String> diasSeleccionados = [];

    TimeOfDay? horaInicio;
    TimeOfDay? horaFin;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (dialogContext, setStateDialog) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(
                "Nueva Materia",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nombreCtrl,
                        decoration: const InputDecoration(
                          labelText: "Nombre",
                          hintText: "Ej. Matemáticas II",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: profesorCtrl,
                        decoration: const InputDecoration(
                          labelText: "Profesor",
                          hintText: "Ej. Prof. Juan Martínez",
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: aulaCtrl,
                        decoration: const InputDecoration(
                          labelText: "Aula",
                          hintText: "Ej. A102",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Días de la semana",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Wrap(
                        spacing: 8.0,
                        children:
                            diasDisponibles.map((dia) {
                              final bool isSelected = diasSeleccionados
                                  .contains(dia);
                              return FilterChip(
                                label: Text(dia),
                                selected: isSelected,
                                onSelected: (bool value) {
                                  setStateDialog(() {
                                    if (value) {
                                      diasSeleccionados.add(dia);
                                    } else {
                                      diasSeleccionados.remove(dia);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setStateDialog(() {
                                    horaInicio = picked;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: "Hora inicio",
                                ),
                                child: Text(
                                  horaInicio == null
                                      ? "Seleccionar"
                                      : horaInicio!.format(context),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setStateDialog(() {
                                    horaFin = picked;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: "Hora fin",
                                ),
                                child: Text(
                                  horaFin == null
                                      ? "Seleccionar"
                                      : horaFin!.format(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final nuevaMateria = Materia(
                        nombre: nombreCtrl.text.trim(),
                        profesor: profesorCtrl.text.trim(),
                        aula: aulaCtrl.text.trim(),
                        diasSemana: diasSeleccionados,
                        horaInicio:
                            horaInicio == null
                                ? ''
                                : horaInicio!.format(context),
                        horaFin:
                            horaFin == null ? '' : horaFin!.format(context),
                      );
                      setState(() {
                        widget.materias.add(nuevaMateria);
                      });
                      widget.onMateriaAdded(nuevaMateria);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Materia agregada correctamente."),
                        ),
                      );
                      widget.onUpdate();
                    }
                  },
                  child: const Text("Guardar ✔️"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
