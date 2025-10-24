

  import 'package:application_sop/modelos%20xlsx/styles_excel.dart';

 String generarUsuarioNas(String nombres, String apellidos, catalogos, areaSelect, usuariosPorArea) {

  Map<String, int> conteoPorArea = {};
  for ( var usuario in usuariosPorArea){
  conteoPorArea[usuario.area] = (conteoPorArea[usuario.area] ?? 0) + 1;
  }
    final inicial = limpiar(nombres).substring(0, 1);
    final apellido = limpiar(apellidos.split(' ').first);
    final area = limpiar(areaSelect).substring(0, 3);
    final num = conteoPorArea[areaSelect]! + 1;
    final numStr = num .toString().padLeft(2, '0');
    final nombreNAS = "$inicial$apellido-$area$numStr";
  
  return nombreNAS;
  }