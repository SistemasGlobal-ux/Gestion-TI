
import 'dart:convert';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/urls.dart';
import 'package:http/http.dart' as http;

class DBProviderUsuario {
  static final DBProviderUsuario db = DBProviderUsuario._();
  DBProviderUsuario._();

  Future getAllUsers() async {
    final response = await http.get(myUrls("USERS"));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      var data = jsonData.map((usuario) => Usuario.fromJson(usuario)).toList();

// Mapas por área y estado
List<Usuario> usuariosActivos = [];
List<Usuario> usuariosBaja = [];

// Agrupamos por área a los usuarios activos
Map<String, List<Usuario>> activosPorArea = {};

// Agrupamos por área a los usuarios dados de baja
Map<String, List<Usuario>> bajaPorArea = {};

for (var usuario in data) {
  String area = usuario.area;
  String estado = usuario.estado.toUpperCase(); // Por si viene en minúsculas

  if (estado == "ACTIVO") {
    // Si no existe la lista para el área, la creamos
    activosPorArea.putIfAbsent(area, () => []);
    activosPorArea[area]!.add(usuario);
  } else if (estado == "BAJA") {
    bajaPorArea.putIfAbsent(area, () => []);
    bajaPorArea[area]!.add(usuario);
  }
}

//Convertimos el mapa de activos en una lista ordenada por área
List<String> areasOrdenadasA = activosPorArea.keys.toList()..sort();
List<String> areasOrdenadasB = bajaPorArea.keys.toList()..sort();

for (var area in areasOrdenadasA) {
  usuariosActivos.addAll(activosPorArea[area]!);
}

for ( var area in areasOrdenadasB){
usuariosBaja.addAll(bajaPorArea[area]!);
}


// 5Retornamos ambos resultados
return {
  "ACTIVOS": usuariosActivos, // Lista ordenada por área
  "BAJA": usuariosBaja        // Mapa agrupado por área
};

    } else {
      throw Exception('Error al cargar los usuarios');
    }

  }

  Future addUser(bodyUser) async {
    var response = await http.post(
      myUrls("ADDUSER"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bodyUser),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = jsonDecode(response.body);
      if (respuesta["status"] == true) {
      return respuesta["id_usuario"];
      }else{
      return respuesta["status"];
      }

    } else {
      LoggerService.write("Error al conectar con el servidor usuarios : ${response.statusCode}");
      throw Exception('Error al conectar con el servidor usuarios');
    }
  }

  Future deleteUser(String idUsuario, String fechaBaja) async {
    final body = {'id': idUsuario, 'fechabaja': fechaBaja};
    final response = await http.post(myUrls("USERBAJA"),headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    if (response.statusCode == 200) {
    final Map<String, dynamic> respuesta = jsonDecode(response.body);
      if(respuesta["status"] == true){
        return true;
      }else{
        return false;
      }
    }else{
      throw Exception("Error al enviar los datos");
    }
  }

  Future deleteU(id) async {
    final body = {"id": id};
    await http.post(myUrls("DELETEUSER"), body: body);
  }

  Future addEquipoUser(newSnEquipo,idUsuario) async {
    final body = {'neSnEquipo': newSnEquipo, 'id': idUsuario};
    final response = await http.post(myUrls("ADDEQUIPOUSER"),headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = jsonDecode(response.body);
      if(respuesta["status"] == true){
        return true;
      }else{
        return false;
      }
    }else{
      throw Exception("Error al enviar los datos");
    }
  }


}