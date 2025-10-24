// ignore_for_file: use_build_context_synchronously

import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/bitacora_semanal.dart';
import 'package:application_sop/modelos%20pdfs/entrega_equipo.dart';
import 'package:application_sop/modelos%20pdfs/inventario_equipos.dart';
import 'package:application_sop/modelos%20pdfs/inventario_usuarios.dart';
import 'package:application_sop/modelos%20pdfs/mant_correctivo.dart';
import 'package:application_sop/modelos%20pdfs/mant_preventivo.dart';
import 'package:application_sop/modelos%20pdfs/pdf_responsiva_extensa.dart';
import 'package:application_sop/modelos%20pdfs/recepcion_equipo.dart';
import 'package:application_sop/modelos%20xlsx/concentrado_equipos.dart';
import 'package:application_sop/modelos%20xlsx/concentrado_soportes.dart';
import 'package:application_sop/modelos%20xlsx/concentrado_usuarios.dart';
import 'package:application_sop/providers/equipos_list.dart';
import 'package:application_sop/providers/usuarios_list.dart';
import 'package:application_sop/services/conexiones.dart';
import 'package:application_sop/services/push_data.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



var conexion = Conexion();

void exportUsersToExcel(List<Usuario> usuarios, String estado, String text,BuildContext context) async {
  // Mostrar el diálogo de carga
  dialogo(context, text);
  try {
    await excelUsuarios(usuarios, estado, context);
    await Future.delayed(Duration(seconds: 1));
  } finally {
    // Cierra el diálogo una vez que termina
    Navigator.of(context).pop();
  }
}

void exportEquiposToExcel(List<Equipo> equipos,List<Usuario> usuariosActivos, String textloading, BuildContext context) async {
  // Mostrar el diálogo de carga
  dialogo(context, textloading);
  try {
  await excelEquipos(equipos, usuariosActivos, context);
  await Future.delayed(Duration(seconds: 1));
  } finally {
    // Cierra el diálogo una vez que termina
    Navigator.of(context).pop();
  }
}

void exportEquiposToPDF(List<Equipo> equipos, String textloading, BuildContext context) async {
  // Mostrar el diálogo de carga
  dialogo(context, textloading);
  try {
  await inventarioEquiposPDF(equipos, context);
  await Future.delayed(Duration(seconds: 1));
  } finally {
    // Cierra el diálogo una vez que termina
    Navigator.of(context).pop();
  }
}

void exportUsuariosToPDF(List<Usuario> usuarios, String textloading, BuildContext context) async {
  // Mostrar el diálogo de carga
  dialogo(context, textloading);
  try {
  await inventarioUsuariosPDF(usuarios, context);
  await Future.delayed(Duration(seconds: 1));
  } finally {
    // Cierra el diálogo una vez que termina
    Navigator.of(context).pop();
  }
}


void generarPdfIngreso(context,Usuario usuario, String text, int i) async {
  dialogo(context, text);
  try {
    
    pdfEntregaEquipo(usuario, usuario.equipos![i], context);
    // Espera 2 segundos antes de cerrar el diálogo
    await Future.delayed(Duration(seconds: 1));
  } finally {
    Navigator.of(context).pop();
  }
}

void generarPdfBaja(context, String text, Usuario usuario) async {
  dialogo(context, text);
  String fecha = myDate(DateTime.now());
  try {
    final resUser = await Provider.of<UsuariosListProvider>(context, listen: false).deleteUserByID(usuario.id!, fecha);
    if(resUser == true){
      if(usuario.equipos!.isNotEmpty){
        for (var e = 0; e < usuario.equipos!.length; e++){
           await Provider.of<EquiposListProvider>(context, listen: false).deleteEquipoUser(usuario.equipos![e].numeroSerie);
           pdfRecepccionEquipo(usuario, usuario.equipos![e], context);
        }

      }
    }
    
    // Espera 2 segundos antes de cerrar el diálogo
    await Future.delayed(Duration(seconds: 1));
  } finally {
    Navigator.of(context).pop();
  }
}

void generarPDFMantPrev(context, usuario, String text) async {
  dialogo(context, text);
  try {
    //String fecha = DateFormat('dd/MM/yyyy').format(DateTime.now());

    for (var i = 0; i < usuario.equipos.length; i++) {
      pdfMantPrevEquipo(usuario, usuario.equipos[i], context);
    }
    // Espera 2 segundos antes de cerrar el diálogo
    await Future.delayed(Duration(seconds: 1));
  } finally {
    Navigator.of(context).pop();
  }
}

void generarPDFMantCorret(context, usuario, String text) async {
  dialogo(context, text);
  try {
    //String fecha = DateFormat('dd/MM/yyyy').format(DateTime.now());
    for (var i = 0; i < usuario.equipos.length; i++) {
      pdfMantCorretEquipo(usuario, usuario.equipos[i], context);
    }
    // Espera 2 segundos antes de cerrar el diálogo
    await Future.delayed(Duration(seconds: 1));
  } finally {
    Navigator.of(context).pop();
  }
}
//////////////////////////////////////////////////
void generarBitacora(context, DateTimeRange dateRange) async {
  dialogo(context, "Creando bitacora semanal...");
  try {
    List listOfDate =  await rangoDeFechas(dateRange);
    var soportes = await conexion.getSoportes(listOfDate.first, listOfDate.last);
    await bitacoraSemanal(context, listOfDate, dateRange, soportes);
    await Future.delayed(Duration(seconds: 1));
  } finally{
    Navigator.of(context).pop();
  }
}
//////////////////////////////////////////////////
void exportDataExcel(context) async {
  dialogo(context, "Exportando info...");
  try {
  var soportes = await conexion.getAllSoportes();
  await excelCSoportes(context, soportes);
  await Future.delayed(Duration(seconds: 2));
  } finally{
    Navigator.of(context).pop();
  }
}
/////////////////////////////////////////////////////////
void generarResponsivaExt(context, usuario, String text,  String especificaciones, String mm, String sn) async {
  dialogo(context, text);
  try {
    //String fecha = DateFormat('dd/MM/yyyy').format(DateTime.now());

    for (var i = 0; i < usuario.equipos.length; i++) {
      responsibaTemp(context, usuario, especificaciones, mm, sn);
    }
    // Espera 2 segundos antes de cerrar el diálogo
    await Future.delayed(Duration(seconds: 1));
  } finally {
    Navigator.of(context).pop();
  }
}

registrarUser(context, text, operativa, sede, ingreso, area, puesto, nombres, apellidos, contacto, notas, snEquipo, estado, baja, nas, correo, correoPassw,correoNotas,email,equipos, catalogos) async {
  dialogo(context, text);
  try {
    final ok =  await Provider.of<UsuariosListProvider>(context, listen: false).newUser(operativa, sede, ingreso, area, puesto, nombres, apellidos, contacto, notas, snEquipo, estado, baja, nas, correo, correoPassw,correoNotas,email,equipos, catalogos, context);
    await Future.delayed(Duration(seconds: 1));
    return ok;
  } finally {
    Navigator.of(context).pop();
  }
}

registrarNewSop(context, text, soporte) async {
  dialogo(context, text);
  try {
    final res = await addSop(soporte, context);
    await Future.delayed(Duration(seconds: 1));
    return res;
  } finally {
    Navigator.of(context).pop();
  }
}

addEquipo(context, String text,user, nas, ingreso, ns) async {
  dialogo(context, text);
  try {
    final res = await Provider.of<UsuariosListProvider>(context, listen: false).newEquipoUser(user, nas, ingreso, ns);
    await Future.delayed(Duration(seconds: 1));
    return res;
  } finally{
    Navigator.of(context).pop();
  }
}