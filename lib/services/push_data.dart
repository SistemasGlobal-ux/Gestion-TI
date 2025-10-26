import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/soportes.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/services/conexiones.dart';

final conexion = Conexion();

Future addUser(Usuario usuario, String nas, context) async {
  //final catalogos = await fetchCatalogos();
  late String res;
  final body =  {};
  final mail = await conexion.checkMail(body);
  final newUser =
      Usuario(
        id: null,
        operativa: usuario.operativa,
        sede: usuario.sede,
        ingreso: usuario.ingreso,
        area: usuario.area,
        puesto: usuario.puesto,
        nombres: usuario.nombres,
        apellidos: usuario.apellidos,
        contacto: usuario.contacto,
        notas: usuario.notas,
        snEquipo: usuario.snEquipo,
        estado: usuario.estado,
        baja: usuario.baja,
        email: mail,
      ).toJson();

  final userid = await conexion.addUser(newUser);

  for (var i = 0; i < usuario.equipos!.length; i++) {
    final equipo =
        Equipo(
          id: usuario.equipos![i].id,
          idUser: userid,
          nas: nas,
          fechaEntrega: usuario.ingreso,
          hojaEntrega: "OK",
        ).toJson();
    res = await conexion.asignarEquipo(equipo);
  }

  if (res == "Proceso completado con exito") {
    //final sede; //= searchDato(catalogos.sedes, int.parse(usuario.sede));
    //final area; //= searchDato(catalogos.areas, int.parse(usuario.area));
    //final puesto; //= searchDato(catalogos.puestos, int.parse(usuario.puesto));
    final finaluser = Usuario(
      operativa: "",
      sede: "sede",
      ingreso: usuario.ingreso,
      area: "area",
      puesto: "puesto",
      nombres: usuario.nombres,
      apellidos: usuario.apellidos,
      contacto: usuario.contacto,
      notas: usuario.notas,
      snEquipo: usuario.snEquipo,
      estado: usuario.estado,
      baja: usuario.baja,
      equipos: usuario.equipos,
    );
    generarPdfIngreso(context, finaluser, "Generando PDF...", 0);
    return "OK";
  } else {
    return res;
  }
}

Future addEquipo(data) async {
  final newEquipo = Equipo(
      id: null,
      idUser: data["id_user"], 
      numeroSerie: data["numero_serie"],
      nas: data["nas"],
      fechaEntrega: data["fecha_entrega"],
      hojaEntrega: data["hoja_entrega"],
      notas: data["notas"],
      baja: data["baja"],
      detalleBaja: data["detalle_baja"],
      discoPrincipal: data["id_disco_principal"].toString(),
      discoSecundario: data["id_disco_secundario"].toString(),
      estado: data["id_estado"].toString(),
      generacion: data["id_generacion"].toString(),
      marca: data["id_marca"].toString(),
      modelo: data["id_modelo"].toString(),
      operativa: data["id_operativa"].toString(),
      procesador: data["id_procesador"].toString(),
      ram: data["id_ram"].toString(),
      recepcion: data["id_recepcion"].toString(),
      sede: data["id_sede"].toString(),
      sistemaOperativo: data["id_sistema_operativo"].toString(),
      tipo: data["id_tipo"].toString()).toJson();

  final equipo = await conexion.addEquipo(newEquipo);
  
 return equipo != null ? equipo["status"] : false;
}

Future addSop(Soportes soporte, context) async {
  final newSop = Soportes(
  idUsuario: soporte.idUsuario, 
  idTecnico: soporte.idTecnico, 
  idSede: soporte.idSede, 
  idTipoSop: soporte.idTipoSop, 
  idTipoFalla: soporte.idTipoFalla, 
  idEstado: soporte.idEstado, 
  idPrioridad: soporte.idPrioridad, 
  problema: soporte.problema, 
  solucion: soporte.solucion, 
  fechaInicio: soporte.fechaInicio, 
  fechaCierre: soporte.fechaCierre, 
  notas: soporte.notas).toJson();
  final res = await conexion.addSoporte(newSop);
  return res;
}

Future addNewDato(String tabla, String columna, String dato) async {
 final res = await conexion.addDato(tabla, columna, dato);
 return res; 
}

String searchDato(List<dynamic> lista, dynamic id) {
  for (var item in lista) {
    if (item.id.toString() == id.toString()) {
      return item.nombre; // O item.area / item.sede según el catálogo
    }
  }
  return "";
}
