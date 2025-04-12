import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dashboard.dart';
import 'horarios.dart';
import 'materias.dart';
import 'tareas.dart';
import 'examenes.dart';
import 'configuracion.dart';
import '../models/materia.dart';
import '../models/tarea.dart';
import '../models/examen.dart';

class ActivityHorario {
  final String title;
  final String type;
  final String startTime;
  final String endTime;
  final String location;
  final String professor;

  ActivityHorario({
    required this.title,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.professor,
  });
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback onLogout;
  
  const HomeScreen({
    super.key, 
    required this.toggleTheme,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Map<int, List<ActivityHorario>> scheduleData = {
    0: [],
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
  };

  final List<Materia> _materias = [];

  final List<Tarea> _tareas = [];

  final List<Examen> _examenes = [];

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(scheduleData: scheduleData),
      HorarioScreen(
        scheduleData: scheduleData,
        onUpdate: _updateSchedule,
        materias: _materias,
        tareas: _tareas,
        examenes: _examenes,
      ),
      MateriasScreen(
        materias: _materias,
        onUpdate: () => setState(() {}),
        onMateriaAdded: (materia) {
          _addMateriaToSchedule(materia);
        },
      ),
      TareasScreen(tareas: _tareas, onUpdate: _updateSchedule),
      ExamenesScreen(examenes: _examenes, onUpdate: _updateSchedule),
      ConfiguracionScreen(onLogout: widget.onLogout),
    ];
  }

  int _dayIndexFromName(String day) {
    const daysMap = {
      "Lun": 0,
      "Mar": 1,
      "Mié": 2,
      "Jue": 3,
      "Vie": 4,
      "Sáb": 5,
      "Dom": 6,
    };
    return daysMap[day] ?? 0;
  }

  void _addMateriaToSchedule(Materia materia) {
    for (String dia in materia.diasSemana) {
      int dayIndex = _dayIndexFromName(dia);
      if (materia.horaInicio.isNotEmpty && materia.horaFin.isNotEmpty) {
        ActivityHorario nuevaActividad = ActivityHorario(
          title: materia.nombre,
          type: "Clase",
          startTime: materia.horaInicio,
          endTime: materia.horaFin,
          location: materia.aula,
          professor: materia.profesor,
        );
        setState(() {
          scheduleData[dayIndex]?.add(nuevaActividad);
        });
      }
    }
  }

  void _updateSchedule() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: Scaffold(
        appBar: AppBar(
          title: const Text('Agenda Escolar'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Horario',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materias'),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: 'Tareas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar),
              label: 'Exámenes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Config',
            ),
          ],
        ),
      ),
      desktop: Scaffold(
        appBar: AppBar(
          title: const Text('Agenda Escolar'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text('Inicio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.schedule),
                  label: Text('Horario'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book),
                  label: Text('Materias'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.check_circle_outline),
                  label: Text('Tareas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.edit_calendar),
                  label: Text('Exámenes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Config'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      ),
      tablet: Scaffold(
        appBar: AppBar(
          title: const Text('Agenda Escolar'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text('Navegación'),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Inicio'),
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Horario'),
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Materias'),
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Tareas'),
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_calendar),
                title: const Text('Exámenes'),
                onTap: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Config'),
                onTap: () {
                  setState(() {
                    _currentIndex = 5;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: _screens[_currentIndex],
      ),
    );
  }
}
