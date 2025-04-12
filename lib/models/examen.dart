class Examen {
  final int id;
  final String materia;
  final DateTime fecha;

  Examen({required this.id, required this.materia, required this.fecha});

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'],
      materia: json['materia'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
