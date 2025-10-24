class Correos {
  final String? id;
  final String dominio, asignacion, passw, notas;

  Correos({
    this.id,
    required this.dominio,
    required this.asignacion,
    required this.passw,
    required this.notas,
  });

  // Método para crear un Correos desde un mapa (como el que viene del JSON)
  factory Correos.fromJson(Map<String, dynamic> json) {
    return Correos(
      id: json['id'],
      dominio: json['dominio'] ?? "",
      asignacion: json['asignacion'] ?? "",
      passw: json['passw'] ?? "",
      notas: json['notas'] ?? "",
    );
  }

  // Método para convertir un Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      'dominio': dominio,
      'asignacion': asignacion,
      'passw': passw,
      'notas': notas,
    };
  }
}
