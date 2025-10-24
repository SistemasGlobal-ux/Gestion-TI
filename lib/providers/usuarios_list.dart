
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/providers/365_list.dart';
import 'package:application_sop/providers/equipos_db_conexion.dart';
import 'package:application_sop/providers/usuarios_db_conexion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuariosListProvider extends ChangeNotifier{

  List<Usuario> users = [];
  List<Usuario> usersBaja = [];

  Future newUser(operativa, sede, ingreso, area, puesto, nombres, apellidos, contacto, notas, snEquipo, estado, baja, nas, correo, correoPassw,correoNotas,email,equipos, catalogos, context) async {
   //Se registra el correo institucional y si es exitoso se prosigue con el usuario
   final idmail = await Provider.of<C365Listproviders>(context, listen: false).new365(correo, correoPassw);
   if (idmail != false) {
    //se registra el usuario en la base de datos y se es exitoso se prosigue asignando el equipo
   final newUser = Usuario(id: null, operativa: operativa, sede: sede, ingreso: ingreso, area: area, puesto: puesto, nombres: nombres, apellidos: apellidos, contacto: contacto, notas: notas, snEquipo: snEquipo, estado: estado, baja: baja, email: idmail).toJson();
   final userid = await DBProviderUsuario.db.addUser(newUser);
   if (userid != false) {
   final equipores =  await DBProviderEquipos.db.updateEstadoEquipo(userid, nas, ingreso, snEquipo);
   if (equipores != false) {
   final newUserf = Usuario(id: userid, operativa: operativa, sede: sede, ingreso: ingreso, area: area, puesto: puesto, nombres: nombres, apellidos: apellidos, contacto: contacto, notas: notas, snEquipo: snEquipo, estado: estado, baja: baja, email: idmail, correo: correo, psw: correoPassw, equipos: equipos);
   users.add(newUserf);
   loadusers();
   notifyListeners();
   return "OK";
   }else{
    await Provider.of<C365Listproviders>(context, listen: false).delete365(idmail);
     await DBProviderUsuario.db.deleteU(userid);
    return false;
   }
   } else{
    await Provider.of<C365Listproviders>(context, listen: false).delete365(idmail);
    return false;
   }
   }else {
    //alerta de erro al registrar correo
    return false;
   }
  }

  newEquipoUser(Usuario user, String nas, String ingreso, String snEquipo) async {
    final equipores =  await DBProviderEquipos.db.updateEstadoEquipo(user.id, nas, ingreso, snEquipo);
    if (equipores != false) {
    final index = users.indexWhere((u) => u.id == user.id);
      if (index == -1) return; // No encontrado
      Usuario userToUpdate = users[index];
      if (userToUpdate.snEquipo.isEmpty) {
      userToUpdate.snEquipo = snEquipo;
      }else {userToUpdate.snEquipo = "${userToUpdate.snEquipo}, $snEquipo";}
      users[index] = userToUpdate;
      final res =  await DBProviderUsuario.db.addEquipoUser(userToUpdate.snEquipo, user.id.toString());
      loadusers();
      notifyListeners();
      return res;
    }

  }

  loadusers() async {
  final users = await DBProviderUsuario.db.getAllUsers();
  this.users = users["ACTIVOS"];
  usersBaja = users["BAJA"];
   notifyListeners();
  }

  //deleteuserByID(String id, String fechaBaja) async {
  //final response = await DBProviderUsuario.db.deleteUser(id, fechaBaja);
  //users.removeWhere((user) => user!.id == id);
  //notifyListeners();
  //return response;
  //}


 Future deleteUserByID(String id, String fechaBaja) async {
  // Buscar el usuario en la lista principal
  final index = users.indexWhere((u) => u.id == id);
  if (index == -1) return; // No encontrado
  // Obtener el usuario
  Usuario userToDelete = users[index];
  // Actualizar fecha y estado
  userToDelete.baja = fechaBaja;
  userToDelete.estado = "BAJA";
  // Eliminar de la lista de activos
  users.removeAt(index);
  // Agregar a lista de baja
  usersBaja.add(userToDelete);
  // Actualizar en base de datos
 final res =  await DBProviderUsuario.db.deleteUser(id.toString(), fechaBaja);
  // Notificar a los listeners (si usas Provider)
  notifyListeners();
  return res;
}

}
