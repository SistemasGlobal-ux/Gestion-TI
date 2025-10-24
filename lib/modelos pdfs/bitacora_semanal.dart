import 'package:application_sop/maps/soportes.dart';
import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/modelos pdfs/pdf_style.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/utils/custom_listas.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

extension StringCasingExtension on String {
  String capitalize() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

Future bitacoraSemanal(
    context, List listDate, DateTimeRange dateRange, List<Soportes> soportes) async {

  TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;
  
  
  List<Soportes> ordenarSoportes = [];
  DateFormat parseFormat = DateFormat("d/M/y");
  var fechatitulo =
      "${myDate(dateRange.start).replaceAll("/", "-")} al ${myDate(dateRange.end).replaceAll("/", "-")}";

  // Filtrar los soportes dentro del rango/listDate
  for (var sop = 0; sop < soportes.length; sop++) {
    for (var days = 0; days < listDate.length; days++) {
      if (soportes[sop].fechaCierre == listDate[days]) {
        ordenarSoportes.add(soportes[sop]);
      }
    }
  }

  // Agrupar por fecha exacta con nombre de día
  Map<DateTime, List<Soportes>> soportesPorFecha = {};

for (var soporte in ordenarSoportes) {
  final fecha = parseFormat.parse(soporte.fechaCierre);

  if (!soportesPorFecha.containsKey(fecha)) {
    soportesPorFecha[fecha] = [];
  }
  soportesPorFecha[fecha]!.add(soporte);
}
  // Crear el PDF
  List<int> bytes = [];
  PdfDocument document = PdfDocument();
  final page = document.pages.add();
  PdfGrid grid = PdfGrid();
  grid.columns.add(count: 12);

  // TÍTULO PRINCIPAL
  PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].columnSpan = 12;
  titulo(headerRow, 0, "BITÁCORA SEMANAL DE ACTIVIDADES", 18);

  // ENCABEZADO DE DATOS DEL RESPONSABLE
  PdfGridRow datos = grid.rows.add();
  datos.cells[0].columnSpan = 12;
  celdaDato(datos, 0, "DATOS DE RESPONSABLE DE TI", 12);

  PdfGridRow info = grid.rows.add();
  celdaDato(info, 0, "Nombre", 8);
  info.cells[1].columnSpan = 4;
  celdaValor(info, 1,"${tecnico.nombres} ${tecnico.apellidos}");
  celdaDato(info, 5, "Sede", 8);
  info.cells[6].columnSpan = 2;
  celdaValor(info, 6, "MARCELO");
  celdaDato(info, 8, "Fecha", 8);
  info.cells[9].columnSpan = 3;
  celdaValor(info, 9, "Del ${listDate.first} al ${listDate.last}");

  // TÍTULO DE SECCIÓN
  PdfGridRow inicio = grid.rows.add();
  inicio.cells[0].columnSpan = 12;
  celdaDato(inicio, 0, "Desglose de actividades por día", 10);

  // ORDENAR LAS FECHAS POR ORDEN CRONOLÓGICO
final fechasOrdenadas = soportesPorFecha.keys.toList()..sort();

for (var fecha in fechasOrdenadas) {
  final listaSoportes = soportesPorFecha[fecha]!;

  final tituloFecha = DateFormat("EEEE - dd/MM/yyyy", "es_MX")
      .format(fecha)
      .capitalize();

  PdfGridRow headerFecha = grid.rows.add();
  headerFecha.cells[0].columnSpan = 12;
  celdaDatoStart(headerFecha, 0, "   $tituloFecha", 10);

  for (var soporte in listaSoportes) {
    PdfGridRow fila = grid.rows.add();
    fila.cells[0].columnSpan = 12;
    final text = sedeMap[int.parse(soporte.idSede)] == "MARCELO" ? " - ${soporte.nombreUsuario}, ${soporte.problema}, ${soporte.solucion}." : " - ${soporte.nombreUsuario}(${sedeMap[int.parse(soporte.idSede)]}), ${soporte.problema}, ${soporte.solucion}."; 
    miDatoList(fila, 0, text, 8);
  }
}
  // LÍNEA FINAL
  PdfGridRow line = grid.rows.add();
  line.cells[0].columnSpan = 12;
  celdaDato(line, 0, " ", 5);

  // DIBUJAR EL GRID
  grid.draw(page: page, bounds: const Rect.fromLTWH(0, 12, 0, 0));
  bytes = await document.save();
  document.dispose();

  saveFile(bytes, "Bitacora_${tecnico.nombres}_$fechatitulo", "BITACORAS SEMANALES", context, "pdf");
}
