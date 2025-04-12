class Horario {
  final int id;
  final String materia;
  final String horaInicio;
  final String horaFin;
  final String dia;

  Horario({
    required this.id,
    required this.materia,
    required this.horaInicio,
    required this.horaFin,
    required this.dia,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      id: json['id'],
      materia: json['materia'],
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      dia: json['dia'],
    );
  }
}
