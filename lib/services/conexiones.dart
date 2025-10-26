import 'dart:convert';

import 'package:application_sop/maps/correos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/soportes.dart';
import 'package:application_sop/maps/tecnicos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/urls.dart';
import 'package:http/http.dart' as http;

class Conexion {
  Future getInfoUsers() async {
    final response = await http.get(myUrls("USERS"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      var data = jsonData.map((usuario) => Usuario.fromJson(usuario)).toList();

      // Mapas por área y estado
      Map<String, List<Usuario>> usuariosActivos = {};
      Map<String, List<Usuario>> usuariosBaja = {};

      for (var usuario in data) {
        String area = usuario.area;
        String estado =
            usuario.estado.toUpperCase(); // Por si viene en minúsculas

        if (estado == "ACTIVO") {
          if (!usuariosActivos.containsKey(area)) {
            usuariosActivos[area] = [];
          }
          usuariosActivos[area]!.add(usuario);
        } else if (estado == "BAJA") {
          if (!usuariosBaja.containsKey(area)) {
            usuariosBaja[area] = [];
          }
          usuariosBaja[area]!.add(usuario);
        }
      }

      // Puedes devolver uno, ambos, o combinarlos
      return {"ACTIVOS": usuariosActivos, "BAJA": usuariosBaja};
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  Future getAllUsers() async {
    final response = await http.get(myUrls("USERS"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      var data = jsonData.map((usuario) => Usuario.fromJson(usuario)).toList();
      return data;
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  Future getInfoEquipos() async {
    final response = await http.get(myUrls("EQUIPOS"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<Equipo> data =
          jsonData.map((equipo) => Equipo.fromJson(equipo)).toList();
      return data;
    } else {
      throw Exception('Error al cargar equipos');
    }
  }

  Future getInfoMails() async {
    final response = await http.get(myUrls("MAILS"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<Correos> data =
          jsonData.map((correo) => Correos.fromJson(correo)).toList();
      return data;
    } else {
      throw Exception('Error al cargar los correos');
    }
  }

  Future getTecnicos() async {
    final response = await http.get(myUrls("TECNICOS"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<Tecnico> data =
          jsonData.map((tecnico) => Tecnico.fromJson(tecnico)).toList();
      return data;
    } else {
      throw Exception('Error al cargar los ingeñeros');
    }
  }

  Future<void> darDeBajaUsuario({
    required String idUsuario,
    required String fechaBaja,
  }) async {
    final response = await http.post(
      myUrls("USERBAJA"),
      body: {'id': idUsuario.toString(), 'fechabaja': fechaBaja},
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception("Error al enviar los datos");
    }
  }

  Future checkMail(body) async {
    var response = await http.post(myUrls("ADDMAIL"),
      headers: {"Content-Type": "application/json"},
      //TODO: ya se registra, manejar cuando no, para cnacelar registro.
      body: jsonEncode(body),
    );
    final respuesta = jsonDecode(response.body);
    if (respuesta['status'] == true) {
      String idEmail = respuesta['id_mail'];
      return idEmail;
    }else{
      print(respuesta);
    }
  }

  Future addUser(body) async {
    var response = await http.post(
      myUrls("ADDUSER"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = jsonDecode(response.body);
      return respuesta["id_usuario"];
    } else {
      LoggerService.write("Error al conectar con el servidor usuarios : ${response.statusCode}");
      throw Exception('Error al conectar con el servidor usuarios');
    }
  }

  Future addEquipo(body) async {
    var response = await http.post(myUrls("ADDEQUIPO"), headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = jsonDecode(response.body);
     return respuesta["status"] == true ? respuesta : null;
    }else{
      LoggerService.write("Error al conectar con el servidor equipos : ${response.statusCode}");
    }

  }

  Future addSoporte(body) async {
    var response = await http.post(myUrls("ADDSOPORTE"),headers: {"Content-Type": "application/json"},body: jsonEncode(body));

    if (response.statusCode == 200) {
    final Map<String, dynamic> respuesta = jsonDecode(response.body);
    return respuesta;
    }else{
      throw Exception('Error al conectar con el servidor');
    }

  }

  Future asignarEquipo(body) async {
    var response = await http.post(
      myUrls("ASIGNAREQUIPO"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == true) {
        json['message'];
      } else {
         json['message'];
      }
    } else {
      return "json['Error HTTP: ${response.statusCode}']";
    }
  }

  Future getSoportes(String fechaInicial, String fechaFinal) async {
  final response = await http.post(myUrls("SOPORTESDATE"),body: {'fechaInicio': fechaInicial, 'fechaCierre': fechaFinal});
  if (response.statusCode == 200) {
  final json = jsonDecode(response.body);
      if (json['status'] == true) {
      List<dynamic> data = json['data'];
      return data.map((item) => Soportes.fromJson(item)).toList();
    } else {
      return [];
    }
  } else{
    LoggerService.write("Error HTTP: ${response.statusCode}");
    return [];
  }
  }

  Future getAllSoportes() async {
    final response = await http.get(myUrls("ALLSOPORTES"));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == true) {
      List<dynamic> data = json['data'];
      return data.map((item) => Soportes.fromJson(item)).toList();
    } else {
      return [];
    }
    }else{
    LoggerService.write("Error HTTP: ${response.statusCode}");
    return [];
    }
  }

  Future addDato(String tabla, String columna, String dato) async {
    final response = await http.post(myUrls("CONSULTAD"), body: {"tabla": tabla, "columna": columna, "dato": dato});
    if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    if (json["status"] == "insertado") {
    return json;
    }else if(json["status"] == "existe"){
      return json;
    }else{
      LoggerService.write("${json["status"]} : ${json["mensaje"]}");
    }
    }else{
      LoggerService.write("Error HTTP: ${response.statusCode}");
    }
  }

}
