class Tarea {
  final int id;
  final String titulo;
  final String descripcion;
  final DateTime fechaEntrega;
  bool isDone;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaEntrega,
    this.isDone = false,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fechaEntrega: DateTime.parse(json['fecha_entrega']),
      isDone: json['isDone'] ?? false,
    );
  }
}
