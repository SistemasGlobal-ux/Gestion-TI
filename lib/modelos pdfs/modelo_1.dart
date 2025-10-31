import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/pdf_style.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future pdfEquipo(
  String header,
  datoObservaciones,
  descripccionObservaciones,
  tipoHoja,
  recibe,
  entrega,
  documento,
  Usuario usuario,
  Equipo equipo,
  context,
  {
  bool mostrarNombreReceptor = true,
}
) async {

  TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;

  List<int> bytes = [];
  PdfDocument document = PdfDocument();

  final page = document.pages.add();
  PdfGrid grid = PdfGrid();

  grid.columns.add(count: 12);

  //TITULO INICIO DE DOCUMENTO
  PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].columnSpan = 12;
  celdaDato(headerRow, 0, header, 18);
  //DATOS COLABORADOS
  PdfGridRow row = grid.rows.add();
  row.cells[0].columnSpan = 12;
  celdaDato(row, 0, "DATOS DEL COLABORADOR", 10);
  //FILA 1 COLABORADOR
  PdfGridRow row2 = grid.rows.add();
  celdaDato(row2, 0, "Nombre", 8);
  row2.cells[1].columnSpan = 5;
  celdaValor(row2, 1, "${usuario.nombres} ${usuario.apellidos}");
  celdaDato(row2, 6, "Area", 8);
  row2.cells[7].columnSpan = 2;
  celdaValor(row2, 7, usuario.area);
  celdaDato(row2, 9, "Sede", 8);
  row2.cells[10].columnSpan = 2;
  celdaValor(row2, 10, usuario.sede);
  //FILA 2 COLABORADOR
  PdfGridRow row3 = grid.rows.add();
  celdaDato(row3, 0, "Correo", 8);
  row3.cells[1].columnSpan = 5;
  celdaValor(row3, 1, usuario.correo ?? "");
  celdaDato(row3, 6, "Puesto", 8);
  row3.cells[7].columnSpan = 2;
  celdaValor(row3, 7, usuario.puesto);
  celdaDato(row3, 9, "ID", 8);
  row3.cells[10].columnSpan = 2;
  celdaValor(row3, 10, "${usuario.id}");

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row4 = grid.rows.add();
  saltoDeCelda(row4, 12);

  PdfGridRow titulo2 = grid.rows.add();
  titulo2.cells[0].columnSpan = 12;
  celdaDato(titulo2, 0, datoObservaciones, 10);

  //HARDWARE
  PdfGridRow row5 = grid.rows.add();
  row5.cells[0].columnSpan = 12;
  celdaDato(row5, 0, "HARDWARE", 10);
  //FILA 1 HARDWARE TITULOS
  PdfGridRow row6 = grid.rows.add();
  row6.cells[0].columnSpan = 2;
  celdaDato(row6, 0, "TIPO", 8);
  row6.cells[2].columnSpan = 3;
  celdaDato(row6, 2, "MARCA / MODELO", 8);
  row6.cells[5].columnSpan = 3;
  celdaDato(row6, 5, "PROCESADOR", 8);
  row6.cells[8].columnSpan = 2;
  celdaDato(row6, 8, "RAM", 8);
  row6.cells[10].columnSpan = 2;
  celdaDato(row6, 10, "D. PRINCIPAL", 8);
  //FILA 1 HARDWARE VALORES
  PdfGridRow row7 = grid.rows.add();
  row7.cells[0].columnSpan = 2;
  celdaValor(row7, 0, equipo.tipo!);
  row7.cells[2].columnSpan = 3;
  celdaValor(row7, 2, "${equipo.marca!} / ${equipo.modelo!}");
  row7.cells[5].columnSpan = 3;
  celdaValor(row7, 5, "${equipo.procesador} ${equipo.generacion}");
  row7.cells[8].columnSpan = 2;
  celdaValor(row7, 8, equipo.ram!);
  row7.cells[10].columnSpan = 2;
  celdaValor(row7, 10, equipo.discoPrincipal!);
  //FILA 2 HARDWARE TITULOS
  PdfGridRow row8 = grid.rows.add();
  row8.cells[0].columnSpan = 2;
  celdaDato(row8, 0, "D. SECUNDARIO", 8);
  row8.cells[2].columnSpan = 3;
  celdaDato(row8, 2, "NUMERO DE SERIE", 8);
  row8.cells[5].columnSpan = 3;
  celdaDato(row8, 5, "USUARIO", 8);
  row8.cells[8].columnSpan = 2;
  celdaDato(row8, 8, "NAS", 8);
  row8.cells[10].columnSpan = 2;
  celdaDato(row8, 10, "EXTRA", 8);
  //FILA 2 HARDWARE VALORES
  PdfGridRow row9 = grid.rows.add();
  row9.cells[0].columnSpan = 2;
  celdaValor(row9, 0, equipo.discoSecundario ?? "");
  row9.cells[2].columnSpan = 3;
  celdaValor(row9, 2, equipo.numeroSerie!);
  row9.cells[5].columnSpan = 3;
  celdaValor(row9,5, usuario.area);
  row9.cells[8].columnSpan = 2;
  celdaValor(row9, 8, equipo.nas ?? "");
  row9.cells[10].columnSpan = 2;
  celdaValor(row9, 10, " ");

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row12 = grid.rows.add();
  saltoDeCelda(row12, 12);

  //SOFTWARE
  PdfGridRow row13 = grid.rows.add();
  row13.cells[0].columnSpan = 12;
  celdaDato(row13, 0, "SOFTWARE", 10);
  //FILA 1 SOFTWARE TITULOS
  PdfGridRow row14 = grid.rows.add();
  row14.cells[0].columnSpan = 4;
  celdaDato(row14, 0, "SOFTWARE ESTÁNDAR CORPORATIVO", 8);
  row14.cells[4].columnSpan = 4;
  celdaDato(row14, 4, "OTRO(S) SOFTWARE SOLICITADO", 8);
  row14.cells[8].columnSpan = 4;
  celdaDato(row14, 8, "CARPETAS COMPARTIDAS", 8);
  //FILA 1 SOFTWARE VALORES
  PdfGridRow row15 = grid.rows.add();
  row15.cells[0].columnSpan = 3;
  celdaValor(row15, 0, equipo.sistemaOperativo!);
  celdaValor(row15, 3, "X");
  row15.cells[4].columnSpan = 3;
  celdaValor(row15, 4, " ");
  celdaValor(row15, 7, " ");
  row15.cells[8].columnSpan = 3;
  celdaValor(row15, 8, " ");
  celdaValor(row15, 11, " ");
  //FILA 2 SOFTWARE VALORES
  PdfGridRow row16 = grid.rows.add();
  row16.cells[0].columnSpan = 3;
  celdaValor(row16, 0, "OFFICE");
  celdaValor(row16, 3, "X");
  row16.cells[4].columnSpan = 3;
  celdaValor(row16, 4, " ");
  celdaValor(row16, 7, " ");
  row16.cells[8].columnSpan = 3;
  celdaValor(row16, 8, " ");
  celdaValor(row16, 11, " ");
  //FILA 3 SOFTWARE VALORES
  PdfGridRow row17 = grid.rows.add();
  row17.cells[0].columnSpan = 3;
  celdaValor(row17, 0, "NITRO PDF");
  celdaValor(row17, 3, "X");
  row17.cells[4].columnSpan = 3;
  celdaValor(row17, 4, " ");
  celdaValor(row17, 7, " ");
  row17.cells[8].columnSpan = 3;
  celdaValor(row17, 8, " ");
  celdaValor(row17, 11, " ");
  //FILA 4 SOFTWARE VALORES
  PdfGridRow row18 = grid.rows.add();
  row18.cells[0].columnSpan = 3;
  celdaValor(row18, 0, "ANYDESK");
  celdaValor(row18, 3, "X");
  row18.cells[4].columnSpan = 3;
  celdaValor(row18, 4, " ");
  celdaValor(row18, 7, " ");
  row18.cells[8].columnSpan = 3;
  celdaValor(row18, 8, " ");
  celdaValor(row18, 11, " ");
  //FILA 5 SOFTWARE VALORES
  PdfGridRow row19 = grid.rows.add();
  row19.cells[0].columnSpan = 3;
  celdaValor(row19, 0, "TEAMVIEWER");
  celdaValor(row19, 3, "X");
  row19.cells[4].columnSpan = 3;
  celdaValor(row19, 4, " ");
  celdaValor(row19, 7, " ");
  row19.cells[8].columnSpan = 3;
  celdaValor(row19, 8, " ");
  celdaValor(row19, 11, " ");
  //FILA 6 SOFTWARE VALORES
  PdfGridRow row20 = grid.rows.add();
  row20.cells[0].columnSpan = 3;
  celdaValor(row20, 0, "WINRAR");
  celdaValor(row20, 3, "X");
  row20.cells[4].columnSpan = 3;
  celdaValor(row20, 4, " ");
  celdaValor(row20, 7, " ");
  row20.cells[8].columnSpan = 3;
  celdaValor(row20, 8, " ");
  celdaValor(row20, 11, " ");
  //FILA 7 SOFTWARE VALORES
  PdfGridRow row21 = grid.rows.add();
  row21.cells[0].columnSpan = 3;
  celdaValor(row21, 0, "EXPLORADOR CHROME");
  celdaValor(row21, 3, "X");
  row21.cells[4].columnSpan = 3;
  celdaValor(row21, 4, " ");
  celdaValor(row21, 7, " ");
  row21.cells[8].columnSpan = 3;
  celdaValor(row21, 8, " ");
  celdaValor(row21, 11, " ");
  //FILA 8 SOFTWARE VALORES
  PdfGridRow row22 = grid.rows.add();
  row22.cells[0].columnSpan = 3;
  celdaValor(row22, 0, "VPN EXPRESS");
  celdaValor(row22, 3, "X");
  row22.cells[4].columnSpan = 3;
  celdaValor(row22, 4, " ");
  celdaValor(row22, 7, " ");
  row22.cells[8].columnSpan = 3;
  celdaValor(row22, 8, " ");
  celdaValor(row22, 11, " ");

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row23 = grid.rows.add();
  saltoDeCelda(row23, 12);

  //OBSERVACIONES
  PdfGridRow row24 = grid.rows.add();
  row24.cells[0].columnSpan = 12;
  celdaDato(row24, 0, """ESTADO FISICO DEL EQUIPO AL MOMENTO DE ENTREGAR
  (Marca con una X la opción que corresponda)""", 10);
  //FILA 1 OBSERVACIONES
  PdfGridRow row25 = grid.rows.add();
  row25.cells[0].columnSpan = 3;
  celdaValor(row25, 0, "BUENO");
  celdaValor(row25, 3, " ");
  row25.cells[4].columnSpan = 3;
  celdaValor(row25, 4, "REGULAR");
  celdaValor(row25, 7, " ");
  row25.cells[8].columnSpan = 3;
  celdaValor(row25, 8, "MALO");
  celdaValor(row25, 11, " ");

  PdfGridRow ddc = grid.rows.add();
  ddc.cells[0].columnSpan = 12;
  celdaDato(ddc, 0, "DECLARACION DE CONFORMIDAD", 10);
   
  //FILA 2 OBSERVACIONEs
  PdfGridRow row26 = grid.rows.add();
  row26.cells[0].columnSpan = 12;
  celdaValor(row26, 0, descripccionObservaciones);

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row27 = grid.rows.add();
  saltoDeCelda(row27, 12);

  //ENTREGA O RECEPCCION DE EQUIPO
  PdfGridRow row28 = grid.rows.add();
  row28.cells[0].columnSpan = 12;
  celdaDato(row28, 0, tipoHoja, 10);
  //FILA 1 ENTREGA DE EQUIPO
  PdfGridRow row29 = grid.rows.add();
  celdaDato(row29, 0, " ", 8);
  row29.cells[0].style.borders = onliLTB;
  row29.cells[1].columnSpan = 5;
  celdaDato(row29, 1, recibe, 8);
  row29.cells[1].style.borders = onliRTB;
  celdaDato(row29, 6, " ", 8);
  row29.cells[6].style.borders = onliLTB;
  row29.cells[7].columnSpan = 5;
  celdaDato(row29, 7, entrega, 8);
  row29.cells[7].style.borders = onliRTB;

  //FILA 2 ENTREGA DE EQUIPOlmmnm
  PdfGridRow row30 = grid.rows.add();
  celdaDato(row30, 0, "NOMBRE", 8);
  row30.cells[1].columnSpan = 5;
  celdaValor(row30, 1,   mostrarNombreReceptor ? "${usuario.nombres} ${usuario.apellidos}" : "",);
  celdaDato(row30, 6, "NOMBRE", 8);
  row30.cells[7].columnSpan = 5;
  celdaValor(
    row30,
    7,
    "${tecnico.nombres} ${tecnico.apellidos}",
  );
  PdfGridRow row31 = grid.rows.add();
  celdaDato(row31, 0, "\n FIRMA \n ", 8);
  row31.cells[1].columnSpan = 5;
  celdaValor(row31, 1, " ");
  celdaDato(row31, 6, "\n FIRMA \n ", 8);
  row31.cells[7].columnSpan = 5;
  celdaValor(row31, 7, " ");
  //FILA 4 ENTREGA DE EQUIPO
  PdfGridRow row32 = grid.rows.add();
  celdaDato(row32, 0, "FECHA", 8);
  row32.cells[1].columnSpan = 5;
  celdaValor(row32, 1, "/                              /");
  celdaDato(row32, 6, "FECHA", 8);
  row32.cells[7].columnSpan = 5;
  celdaValor(row32, 7, "/                              /");

  grid.draw(page: page, bounds: const Rect.fromLTWH(0, 12, 0, 0));

  bytes = await document.save();
  document.dispose();

  final formatTextName = "${usuario.area}_${usuario.nombres}_${equipo.numeroSerie}".replaceAll('\r\n', "").replaceAll('\n', "");
  //final formatTextName = "${usuario.area}_${equipo.numeroSerie}";

  saveFile(
    bytes,
    formatTextName,
    documento,
    context,
    "pdf",
  );
}
