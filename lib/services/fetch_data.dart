
import 'package:application_sop/maps/correos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/tecnicos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/services/conexiones.dart';

final conexion = Conexion();

Future<Map<String, List<Usuario>>?>? fetchUsuariosArea() async {
  final data = await conexion.getInfoUsers();
  return Future.value(data["ACTIVOS"]);
}


//Future<CatalogosCombinados> fetchCatalogosEquipo() async {
  //final c1 = await conexion.getGeneral();
  //final c2 = await conexion.getGeneralEquipo();
  //return CatalogosCombinados(catalogos: [], catalogosE: c2);
//}

Future<List<Equipo>> fetchEquipos() async {
  final equipos = await conexion.getInfoEquipos();
  return equipos;
}

Future<List<Correos>> fetchMails() async {
  var mails = await conexion.getInfoMails();
  //int disponibles = mails.where((c) => c.asignacion == null || c.asignacion == "~").length;
  return mails;
}

Future<List<Tecnico>> obtenerTecnicos() async {
  final conexion = Conexion();
  var tecnicos = await conexion.getTecnicos();
  return tecnicos;
}
