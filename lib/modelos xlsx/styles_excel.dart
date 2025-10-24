
// ignore_for_file: deprecated_member_use

import 'package:application_sop/utils/colors_area.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

globalStyleH1(libro){
CellStyle globalStyle = CellStyle(libro);
    globalStyle.fontSize = 12;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.backColor = "#37D8E9";
    globalStyle.borders.all.lineStyle = LineStyle.thin;
    globalStyle.borders.all.colorRgb = const Color.fromARGB(255, 0, 0, 0);
return globalStyle;
}

globalStyleH2(libro){
  CellStyle globalStyle = CellStyle(libro);
    globalStyle.fontSize = 12;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.backColor = "#37D8E9";
    globalStyle.borders.all.lineStyle = LineStyle.medium;
    globalStyle.borders.all.colorRgb = const Color.fromARGB(255, 0, 0, 0);
    return globalStyle;
}

styleVigente(libro){
  CellStyle globalStyle = CellStyle(libro);
    globalStyle.fontSize = 12;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.backColor = "#37E9A1";
    return globalStyle;
}

styleCancelado(libro){
    CellStyle globalStyle = CellStyle(libro);
    globalStyle.fontSize = 12;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.backColor = "#F24911";
    return globalStyle;
}

styleNormal(libro){
    CellStyle globalStyle = CellStyle(libro);
    globalStyle.fontSize = 12;
    globalStyle.hAlign = HAlignType.center;
    return globalStyle;
}

styleColorA(libro, area){
    final color = myColor(area);
    final hexColor = getColorHexFromColor(color);
    CellStyle globalStyle = CellStyle(libro);
    globalStyle.fontSize = 12;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.backColor = hexColor;
    globalStyle.borders.all.lineStyle = LineStyle.thin;
    globalStyle.borders.all.color = '#000000';
    return globalStyle;
}


String getColorHexFromColor(Color color) {
  final r = color.red.toRadixString(16).padLeft(2, '0');
  final g = color.green.toRadixString(16).padLeft(2, '0');
  final b = color.blue.toRadixString(16).padLeft(2, '0');
  return '#$r$g$b';
}



String limpiar(String texto) {
  return texto
      .replaceAll(RegExp(r'[^\w\s]+'), '') // elimina caracteres especiales
      .toLowerCase()
      .trim();
}

headersUsuarios(){
  return [
          "ESTADO",
          "AREA",
          "PUESTO",
          "NOMBRES",
          "APELLIDOS",
          "CONTACTO",
          "EMAIL",
          "E-MAIL PASS",
          "USUARIO NAS",
          "ACCESO NAS",
          "NOTAS",
          "TIPO",
          "NS - EQUIPO",
          "MARCA",
          "MODELO",
          "PROCESADOR",
          "ALMACENAMIENTO PRINCIPAL",
          "ALMACENAMIENTO SECUNDARIO",
          "RAM",
          "SO"
        ];
}

headerEquipos(){
  return [
    "RECEPCCION",	
    "ESTADO",
    "SEDE",
    "USUARIO",
    "AREA",	
    "NUMERO DE SERIE",
    "TIPO",	
    "MARCA",
    "MODELO",	
    "PROCESADOR",
    "DISCO PRINCIPAL",
    "DISCO SECUNDARIO",
    "MEMORIA RAM",
    "SO",
    "NAS",
    "FECHA DE ENTREGA",
    "HOJA DE ENTREGA",
    "NOTAS",
    "BAJA DE EQUIPO",
    "DETALLE DE BAJA"
  ];
}

headerSoportes(){
  return [
    "Fecha",
    "Usuario",
    "problema",
    "Solucion",
  ];
}