import 'package:application_sop/maps/equipos.dart';

class Usuario {
   String? 
      id,
      correo,
      psw,
      tipolicencia,
      email;
   String operativa,
      sede,
      ingreso,
      area,
      puesto,
      nombres,
      apellidos,
      contacto,
      notas,
      snEquipo,
      estado,
      baja;
   List<Equipo>? equipos;

  Usuario({
    this.id,
    required this.operativa,
    required this.sede,
    required this.ingreso,
    required this.area,
    required this.puesto,
    required this.nombres,
    required this.apellidos,
    required this.contacto,
    required this.notas,
    required this.snEquipo,
    required this.estado,
    required this.baja,
    this.email,
    this.correo,
    this.psw,
    this.tipolicencia,
    this.equipos,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    var equiposFromJson = json['equipos'] as List;
    List<Equipo> equiposList =
        equiposFromJson.map((e) => Equipo.fromJson(e)).toList();

    return Usuario(
      id: json['ID'],
      operativa: json['operativa'] ?? "",
      sede: json['sede'] ?? "",
      ingreso: json['INGRESO'] ?? "",
      area: json['area'] ?? "",
      puesto: json['puesto'] ?? "",
      nombres: json['NOMBRES'] ?? "",
      apellidos: json['APELLIDOS'] ?? "",
      contacto: json['CONTACTO'] ?? "",
      notas: json['NOTAS'] ?? "",
      snEquipo: json['SN_EQUIPO'] ?? "",
      estado: json['ESTADO'] ?? "",
      baja: json['BAJA'] ?? "",
      correo: json['correo'] ?? "",
      psw: json['psw'] ?? "",
      tipolicencia: json['tipo_licencia'] ?? "",
      equipos: equiposList,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "operativa": operativa,
    "sede": sede,
    "ingreso": ingreso,
    "area": area,
    "puesto": puesto,
    "nombres": nombres,
    "apellidos": apellidos,
    "contacto": contacto,
    "email": email,
    "notas": notas,
    "snEquipo": snEquipo,
    "estado": estado,
    "baja": baja,
  };

Usuario.empty()
    : id = null,
      operativa = "",
      sede = "",
      ingreso = "",
      area = "",
      puesto = "",
      nombres = "",
      apellidos = "",
      contacto = "",
      notas = "",
      snEquipo = "",
      estado = "",
      baja = "",
      correo = "",
      psw = "",
      tipolicencia = "",
      equipos = const [],
      email = null;
}
