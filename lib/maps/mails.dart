class Mails {
  final String? id;
  final String correo, psw, tipolicencia, activa, asignada, notas;

  Mails({
    this.id,
    required this.correo,
    required this.psw,
    required this.tipolicencia,
    required this.activa,
    required this.asignada,
    required this.notas,
  });

  // Método para crear un Mails desde un mapa (como el que viene del JSON)
  factory Mails.fromJson(Map<String, dynamic> json) {
    return Mails(
      id: json['id'],
      correo: json["correo"],
      psw: json["psw"],
      tipolicencia: json["tipo_licencia"],
      activa: json["activa"],
      asignada: json["asignada"],
      notas: json["notas"],
    );
  }

  // Método para convertir un Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
     "id" : id,
     "correo" : correo,
     "psw" : psw,
     "tipolicencia" : tipolicencia,
     "activa" : activa,
     "asignada" : asignada,
     "notas" : notas,
    };
  }

  Mails.empty():
   id = "",
   correo = "",
   psw = "",
   tipolicencia = "",
   activa = "",
   asignada = "",
   notas = "";

}
