
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/providers/equipos_db_conexion.dart';
import 'package:application_sop/services/logger.dart';
import 'package:flutter/material.dart';

class EquiposListProvider extends ChangeNotifier{

   List<Equipo> eEntregados = [];
   List<Equipo> estock = [];
   List<Equipo> edanado = [];
   List<Equipo> eporDefinir = []; 
   List<Equipo> otros = [];
   List<Equipo> todosLosEquipos = [];

  Future newEquipo(int recepcion,int operativa,int sede,int tipo,String numeroSerie,int marca,int modelo,int procesador,int generacion,int discoPrincipal,int discoSecundario,int ram,int sistemaOperativo) async {
    final body = {
    "recepcion": "$recepcion",
    "operativa": "$operativa",
    "sede": "$sede",
    "tipo": "$tipo",
    "numeroSerie": numeroSerie,
    "marca": "$marca", 
    "modelo": "$modelo",
    "procesador": "$procesador",
    "generacion": "$generacion",
    "discoPrincipal": "$discoPrincipal", 
    "discoSecundario": "$discoSecundario",
    "ram": "$ram",
    "sistemaOperativo": "$sistemaOperativo"};

   final equipo = await DBProviderEquipos.db.addEquipo(body);
   
   estock.add(Equipo.fromJson(equipo));
   notifyListeners();
  }

  loadEquipos() async {
  final equipos = await DBProviderEquipos.db.getAllEquipos();
  eEntregados = equipos["ENTREGADO"];
  estock = equipos["STOCK"];
  edanado = equipos["PORDEFINIR"];
  eporDefinir = equipos["DAÑADO"];
  otros = equipos["OTROS"];
   notifyListeners();
  }

  loadAllEquipos() async {
      final equipos = await DBProviderEquipos.db.getAllEquipos();
      todosLosEquipos.clear();

for (var lista in [
  equipos["STOCK"],
  equipos["ENTREGADO"],
  equipos["PORDEFINIR"],
  equipos["DAÑADO"],
  equipos["OTROS"]
]) {
  for (var equipo in lista) {
    if (!todosLosEquipos.any((e) => e.id == equipo.id)) {
      todosLosEquipos.add(equipo);
    }
  }
}
      notifyListeners();
  }

  Future deleteEquipoUser(ns) async {
    final status = await DBProviderEquipos.db.bajaEquipoUser(ns);
    if (status == true) {
     final index = eEntregados.indexWhere((u) => u.numeroSerie == ns);
    if (index == -1){LoggerService.write("deleteEquipoByID: No encontrado");}

    Equipo equipoUpdate = eEntregados[index];
    equipoUpdate.idUser = "STOCK";
    equipoUpdate.nas = "~";
    equipoUpdate.estado = "2";
    equipoUpdate.hojaEntrega = "~";
    equipoUpdate.fechaEntrega = "~";
    eEntregados.removeAt(index);
    estock.add(equipoUpdate);
    notifyListeners();
    }
  }

 Future<void> updateEquipoByEstado(idUser, id, estado, notas) async {
  // Buscar el usuario en la lista principal
  await loadAllEquipos();
  final index = todosLosEquipos.indexWhere((u) => u.id == id);
  if (index == -1){LoggerService.write("deleteEquipoByID: No encontrado");} // No encontrado

  // Obtener el equipo
  Equipo equipoToDelete = todosLosEquipos[index];

  // Actualizar fecha y estado
  equipoToDelete.estado = estado;
  equipoToDelete.idUser = "~";
  equipoToDelete.notas = notas;

  if(estado =="ENTREGADO"){
    // Eliminar de la lista de activos
    eEntregados.removeAt(index);
    // Agregar a lista correspondiente
    eEntregados.add(equipoToDelete);
  }
  else if(estado =="STOCK"){
    estock.removeAt(index);
    estock.add(equipoToDelete);
  }
  else if(estado =="POR DEFINIR" ){
    edanado.removeAt(index);
    edanado.add(equipoToDelete);
  }
  else if(estado =="DAÑADO"){
    eporDefinir.removeAt(index);
    eporDefinir.add(equipoToDelete);
  }
  else{
    otros.removeAt(index);
    otros.add(equipoToDelete);
  }
  // Actualizar en base de datos
  await DBProviderEquipos.db.updateEstadoEquipo(idUser, "nas", "fechaEntrega", "ns");
  // Notificar a los listeners (si usas Provider)
  notifyListeners();
}


}