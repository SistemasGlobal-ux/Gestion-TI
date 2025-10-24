import 'dart:ui';

import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/pdf_style.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future pdfMantC(documento, Usuario usuario, Equipo equipo, context) async {
  TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;

  List<int> bytes = [];
  PdfDocument document = PdfDocument();

  final page = document.pages.add();
  PdfGrid grid = PdfGrid();

  //TITULO INICIO DE DOCUMENTO
  grid.columns.add(count: 12);
  PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].columnSpan = 12;
  celdaDato(headerRow, 0, "MANTENIMIENTO CORRECTIVO DE EQUIPO DE COMPUTO", 18);
  //DATOS COLABORADOS
  PdfGridRow row = grid.rows.add();
  row.cells[0].columnSpan = 12;
  celdaDato(row, 0, "DATOS DEL COLABORADOR", 10);
  //FILA 1 COLABORADOR
  PdfGridRow row2 = grid.rows.add();
  celdaDato(row2, 0, "Nombre", 8);
  row2.cells[1].columnSpan = 5;
  celdaValor(row2, 1, "${usuario.nombres} ${usuario.apellidos}");
  celdaDato(row2, 6, "Puesto", 8);
  row2.cells[7].columnSpan = 2;
  celdaValor(row2, 7, usuario.puesto);
  celdaDato(row2, 9, "sede", 8);
  row2.cells[10].columnSpan = 2;
  celdaValor(row2, 10, usuario.sede);
  PdfGridRow row3 = grid.rows.add();
  row3.cells[0].columnSpan = 6;
  celdaDato(row3, 0, "Fecha de solicitud:", 8);
  row3.cells[6].columnSpan = 6;
  celdaValor(row3, 6, "     /                    /");
  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row4 = grid.rows.add();
  saltoDeCelda(row4, 12);
  //HARDWARE
  PdfGridRow row5 = grid.rows.add();
  row5.cells[0].columnSpan = 12;
  celdaDato(row5, 0, "EQUIPO", 10);
  //FILA 1 HARDWARE TITULOS
  PdfGridRow row6 = grid.rows.add();
  row6.cells[0].columnSpan = 2;
  celdaDato(row6, 0, "TIPO", 8);
  row6.cells[2].columnSpan = 2;
  celdaDato(row6, 2, "USUARIO", 8);
  row6.cells[4].columnSpan = 2;
  celdaDato(row6, 4, "CONTRASEÑA", 8);
  row6.cells[6].columnSpan = 3;
  celdaDato(row6, 6, "MARCA / MODELO", 8);
  row6.cells[9].columnSpan = 3;
  celdaDato(row6, 9, "NUMERO DE SERIE", 8);
  //FILA 1 HARDWARE VALORES
  PdfGridRow row7 = grid.rows.add();
  row7.cells[0].columnSpan = 2;
  celdaValor(row7, 0, equipo.tipo!);
  row7.cells[2].columnSpan = 2;
  celdaValor(row7, 2, "");
  row7.cells[4].columnSpan = 2;
  celdaValor(row7, 4, "");
  row7.cells[6].columnSpan = 3;
  celdaValor(row7, 6, "${equipo.marca!} / ${equipo.modelo!}");
  row7.cells[9].columnSpan = 3;
  celdaValor(row7, 9, equipo.numeroSerie!);
  //FILA 2 HARDWARE TITULOS
  PdfGridRow row8 = grid.rows.add();
  row8.cells[0].columnSpan = 2;
  celdaDato(row8, 0, "PROCESADOR", 8);
  row8.cells[2].columnSpan = 2;
  celdaDato(row8, 2, "RAM", 8);
  row8.cells[4].columnSpan = 2;
  celdaDato(row8, 4, "DISCO PRINCIPAL", 8);
  row8.cells[6].columnSpan = 3;
  celdaDato(row8, 6, "DISCO SECUNDARIO", 8);
  row8.cells[9].columnSpan = 3;
  celdaDato(row8, 9, "ID EQUIPO", 8);
  //FILA 2 HARDWARE VALORES
  PdfGridRow row9 = grid.rows.add();
  row9.cells[0].columnSpan = 2;
  celdaValor(row9, 0, "${equipo.procesador!} ${equipo.generacion}");
  row9.cells[2].columnSpan = 2;
  celdaValor(row9, 2, equipo.ram!);
  row9.cells[4].columnSpan = 2;
  celdaValor(row9, 4, equipo.discoPrincipal!);
  row9.cells[6].columnSpan = 3;
  celdaValor(row9, 6, equipo.discoSecundario!);
  row9.cells[9].columnSpan = 3;
  celdaValor(row9, 9, equipo.id!);
  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row10 = grid.rows.add();
  saltoDeCelda(row10, 12);

  //OBSERVACIONES
  PdfGridRow row11 = grid.rows.add();
  row11.cells[0].columnSpan = 12;
  celdaDato(row11, 0, "DESCRIPCIÓN DEL PROBLEMA REPORTADO POR EL USUARIO", 10);
  //FILA 1 OBSERVACIONES
  PdfGridRow row12 = grid.rows.add();
  row12.cells[0].columnSpan = 12;
  celdaValor(row12, 0, """





""");
  //FILA 2 OBSERVACIONEs
  PdfGridRow row13 = grid.rows.add();
  row13.cells[0].columnSpan = 12;
  celdaDato(row13, 0, "DIAGNÓSTICO DEL TÉCNICO", 10);
  PdfGridRow row14 = grid.rows.add();
  row14.cells[0].columnSpan = 12;
  celdaValor(row14, 0, """





""");

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row15 = grid.rows.add();
  saltoDeCelda(row15, 12);

  PdfGridRow row16 = grid.rows.add();
  row16.cells[0].columnSpan = 12;
  celdaDato(row16, 0, "ESTADO FINAL DEL EQUIPO:", 10);

  PdfGridRow row17 = grid.rows.add();
  row17.cells[0].columnSpan = 11;
  celdaValorStart(row17, 0, "  Operativo y funcionando correctamente");
  celdaValor(row17, 11, "[       ]");
  PdfGridRow row18 = grid.rows.add();
  row18.cells[0].columnSpan = 11;
  celdaValorStart(row18, 0, "  Funcionando con observaciones");
  celdaValor(row18, 11, "[       ]");
  PdfGridRow row19 = grid.rows.add();
  row19.cells[0].columnSpan = 11;
  celdaValorStart(row19, 0, "  No funcional - requiere revisión adicional");
  celdaValor(row19, 11, "[       ]");
  PdfGridRow row20 = grid.rows.add();
  row20.cells[0].columnSpan = 11;
  celdaValorStart(row20, 0, "  Equipo dado de baja");
  celdaValor(row20, 11, "[       ]");

  //OBSERVACIONES
  PdfGridRow row21 = grid.rows.add();
  row21.cells[0].columnSpan = 12;
  celdaDato(row21, 0, "OBSERVACIONES", 10);
  //FILA 2 OBSERVACIONEs
  PdfGridRow row22 = grid.rows.add();
  row22.cells[0].columnSpan = 12;
  celdaValor(row22, 0, """









""");

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow rows = grid.rows.add();
  saltoDeCelda(rows, 12);

  //ENTREGA O RECEPCCION DE EQUIPO
  PdfGridRow row23 = grid.rows.add();
  row23.cells[0].columnSpan = 12;
  celdaDato(row23, 0, "FIRMAS DE CONFORMIDAD", 10);
  //FILA 1 ENTREGA DE EQUIPO
  PdfGridRow row24 = grid.rows.add();
  celdaDato(row24, 0, " ", 8);
  row24.cells[0].style.borders = onliLTB;
  row24.cells[1].columnSpan = 5;
  celdaDato(row24, 1, "USUARIO", 8);
  row24.cells[1].style.borders = onliRTB;
  celdaDato(row24, 6, " ", 8);
  row24.cells[6].style.borders = onliLTB;
  row24.cells[7].columnSpan = 5;
  celdaDato(row24, 7, "TECNICO RESPONSABLE", 8);
  row24.cells[7].style.borders = onliRTB;

  //FILA 2 ENTREGA DE EQUIPO
  PdfGridRow row25 = grid.rows.add();
  celdaDato(row25, 0, "NOMBRE", 8);
  row25.cells[1].columnSpan = 5;

  celdaValor(row25, 1, "${usuario.nombres} ${usuario.apellidos}");
  celdaDato(row25, 6, "NOMBRE", 8);
  row25.cells[7].columnSpan = 5;
  celdaValor(
    row25,
    7,
    "${tecnico.nombres} ${tecnico.apellidos}",
  );
  PdfGridRow row26 = grid.rows.add();
  celdaDato(row26, 0, "\n FIRMA \n ", 8);
  row26.cells[1].columnSpan = 5;
  celdaValor(row26, 1, " ");
  celdaDato(row26, 6, "\n FIRMA \n ", 8);
  row26.cells[7].columnSpan = 5;
  celdaValor(row26, 7, " ");
  //FILA 4 ENTREGA DE EQUIPO
  PdfGridRow row27 = grid.rows.add();
  celdaDato(row27, 0, "FECHA", 8);
  row27.cells[1].columnSpan = 5;
  celdaValor(row27, 1, "/                              /");
  celdaDato(row27, 6, "FECHA", 8);
  row27.cells[7].columnSpan = 5;
  celdaValor(row27, 7, "/                              /");

  grid.draw(page: page, bounds: const Rect.fromLTWH(0, 12, 0, 0));
  bytes = await document.save();
  document.dispose();

  saveFile(
    bytes,
    "${usuario.area}_${usuario.nombres}_${equipo.numeroSerie}",
    documento,
    context,
    "pdf",
  );
}
