

import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/providers/tech_suppor_db_conexion.dart';
import 'package:application_sop/services/logger.dart';
import 'package:flutter/material.dart';

class TechSupporListProvider extends ChangeNotifier{

  TechSuppor tecnico = TechSuppor.empty();

  Future<TechSuppor> newTecnico(nombres, apellidos, mail, sede, rol) async{
    final token = "16numerosyletras";
    final activo = "1"; //1 de true
    TechSuppor newTech = TechSuppor(token: token, nombres: nombres, apellidos: apellidos, mail: mail, sede: sede, rol: rol, activo: activo);
    await DBProviderTechSuppor.db.addTecnico(newTech);
    //tecnico.add(newTech);
    notifyListeners();
    return newTech;
  }

  checkTecnico(mail, psw) async {
    final response = await DBProviderTechSuppor.db.checkTecnico(mail, psw);
    if (response.toString().contains("Error")){
      LoggerService.write("$response");
      return {"status": false, "response":response};
    }else{
      return {"status": true, "response":response};
    }
  }

  loadTecnico(token) async {
    final tecnico = await DBProviderTechSuppor.db.getTecnico(token);
    if (tecnico.toString().contains("Error")){
    }else{
      this.tecnico = TechSuppor.fromJson(tecnico);
    }
    notifyListeners();
  }

  loadAllTecnicos() async{}




}