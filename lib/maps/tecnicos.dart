class Tecnico {
  final String id, nombres, apellidos, email, dominio, sede;

  Tecnico({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.dominio,
    required this.sede,
  });

  // Método para crear un Tecnico desde un mapa (como el que viene del JSON)
  factory Tecnico.fromJson(Map<String, dynamic> json) {
    return Tecnico(
      id: json["id"],
      nombres: json['nombres'] ?? "",
      apellidos: json['apellidos'] ?? "",
      email: json['email'] ?? "",
      dominio: json['dominio'] ?? "",
      sede: json["sede"] ?? "",
    );
  }

  // Método para convertir un Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'dominio': dominio,
      "sede": sede,
    };
  }
}
