class Materia {
  final String nombre;
  final String profesor;
  final String aula;
  final List<String> diasSemana;
  final String horaInicio;
  final String horaFin;

  Materia({
    required this.nombre,
    this.profesor = '',
    this.aula = '',
    required this.diasSemana,
    this.horaInicio = '',
    this.horaFin = '',
  });
}
