import 'dart:convert';

Soportes soportesFromJson(String str) => Soportes.fromJson(json.decode(str));
String soportesToJson(Soportes data) => json.encode(data.toJson());

class Soportes{
    String? id, nombreUsuario, nombreTecnico;
    String idUsuario, idTecnico, idSede, idTipoSop, idTipoFalla, idEstado, idPrioridad, problema, solucion,fechaInicio, fechaCierre, notas;

  Soportes({
    this.id,
    this.nombreUsuario,
    this.nombreTecnico,
    required this.idUsuario,
    required this.idTecnico,
    required this.idSede,
    required this.idTipoSop,
    required this.idTipoFalla,
    required this.idEstado,
    required this.idPrioridad,
    required this.problema,
    required this.solucion,
    required this.fechaInicio,
    required this.fechaCierre,
    required this.notas,
  });

  factory Soportes.fromJson(Map<String, dynamic> json) => Soportes(
    id: json["id"] ?? "",
    idUsuario: json["idUsuario"] ?? "",
    nombreUsuario: json["nombreUsuario"] ?? "",
    nombreTecnico: json["nombreTecnico"] ?? "",
    idTecnico: json["idTecnico"] ?? "", 
    idSede: json["idSede"] ?? "", 
    idTipoSop: json["idTipoSop"] ?? "", 
    idTipoFalla: json["idTipoFalla"] ?? "", 
    idEstado: json["idEstado"] ?? "", 
    idPrioridad: json["idPrioridad"] ?? "", 
    problema: json["problema"] ?? "", 
    solucion: json["solucion"] ?? "", 
    fechaInicio: json["fechaInicio"] ?? "", 
    fechaCierre: json["fechaCierre"] ?? "", 
    notas: json["notas"] ?? "");

  Map<String, dynamic> toJson() => {
    "id": id,
    "idUsuario": idUsuario,
    "idTecnico": idTecnico,
    "idSede": idSede,
    "idTipoSop": idTipoSop,
    "idTipoFalla": idTipoFalla,
    "idEstado": idEstado,
    "idPrioridad": idPrioridad,
    "problema": problema,
    "solucion": solucion,
    "fechaInicio": fechaInicio,
    "fechaCierre": fechaCierre,
    "notas": notas,
  };

}