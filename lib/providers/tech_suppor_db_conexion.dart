


import 'dart:convert';

import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/urls.dart';
import 'package:http/http.dart' as http;

class DBProviderTechSuppor {
  static final DBProviderTechSuppor db = DBProviderTechSuppor._();
  DBProviderTechSuppor._();

  Future checkTecnico(mail, psw) async {
    final body = {"mail" : mail,"psw" : psw};
    final response = await http.post(myUrls("CHEKTECNICO"), body: body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = json.decode(response.body);
      if (respuesta["status"] == true) {
       return respuesta["token"];
      }else{
        return "Error: ${respuesta["message"]}";
      }
    }else{
      return "Error al conectar con el servidor: ${response.statusCode}";
    }
   }

  Future getTecnico(token) async {
    final body = {"token" : token};
    final response = await http.post(myUrls("GETTECNICO"), body: body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> respuesta = json.decode(response.body);

      if (respuesta["status"] == true) {
       return respuesta["tecnico"];
      }else{
        LoggerService.write("${respuesta["status"]}: ${respuesta["message"]}");
        return "Error: ${respuesta["message"]} ";
      }
    }else{
      LoggerService.write("Error al conectar con el servidor: ${response.statusCode}");
      return "Error al conectar con el servidor";
    }

  }

  Future getAllTecnicos() async {}

  Future addTecnico(TechSuppor newTech) async {}

  Future deleteTecnico() async {}
}