import 'dart:convert';

import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/urls.dart';
import 'package:http/http.dart' as http;

class DBProviderEquipos {
  static final DBProviderEquipos db = DBProviderEquipos._();
  DBProviderEquipos._();

  Future getAllEquipos() async {
    final response = await http.get(myUrls("EQUIPOS"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      var data = jsonData.map((equipo) => Equipo.fromJson(equipo)).toList();

   // Mapas por área y estado
   List<Equipo> entregados = [];
   List<Equipo> stock = [];
   List<Equipo> danado = [];
   List<Equipo> porDefinir = []; 
   List<Equipo> otro = [];

   for (var equipo in data) {
     String estado = equipo.estado!.toUpperCase();
     if (estado == "ENTREGADO") {
      entregados.add(equipo);
     } else if (estado == "STOCK") {
      stock.add(equipo);
     }else if(estado == "POR DEFINIR"){
      porDefinir.add(equipo);
     }else if(estado == "DAÑADO"){
      danado.add(equipo);
     }else{
      otro.add(equipo);
     }
   }
   // Retornamos resultados
   return {
    "ENTREGADO": entregados, 
    "STOCK": stock,
    "PORDEFINIR": porDefinir,
    "DAÑADO": danado,
    "OTROS": otro
    };

    } else {
      LoggerService.write("Error al cargar los usuarios ${response.statusCode}");
    }

  }

  Future addEquipo(Equipo newEquipo) async {
    var response = await http.post(myUrls("ADDEQUIPO"), headers: {"Content-Type": "application/json"}, body: jsonEncode(newEquipo));

    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = jsonDecode(response.body);
      
     if(respuesta["status"] == true) {
      return respuesta["id_equipo"];}
      else{
        LoggerService.write("${respuesta["status"]}: ${respuesta["message"]}");
      }

    } else {
      LoggerService.write("Error al conectar con el servidor equipos : ${response.statusCode}");
    }
  }

  Future updateEstadoEquipo(newIdUser, nas, fechaEntrega, ns) async {
     final bodyupdate = {'id_usuario' : newIdUser,'nas' : nas,'fecha_entrega' : fechaEntrega,'nsEquipo' : ns};
     var response = await http.post(myUrls("ASIGNAREQUIPO"), headers: {"Content-Type": "application/json"}, body: jsonEncode(bodyupdate));
      if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = jsonDecode(response.body);
      if(respuesta["status"] == true) {
      return respuesta["message"];}
      else{
        LoggerService.write("${respuesta["status"]}: ${respuesta["message"]}");
        return false;
        }
      }else {
      LoggerService.write("Error al conectar con el servidor equipos : ${response.statusCode}");
      return false;
    }
  }

  Future bajaEquipoUser(ns) async {
    final body = {"ns": ns};
    var response = await http.post(myUrls("EQUIPOBAJA"), headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    if(response.statusCode == 200){
      final Map<String, dynamic> respuesta = jsonDecode(response.body);
      if(respuesta["status"] == true) {return true;}else{return false;}
    }
  }

  Future bajaEquipo(String idEquipo, String fechaBaja, String detalleBaja, estado, idUser, nas, fechaEntrega, hojaEntrega, notas) async {

  }

}