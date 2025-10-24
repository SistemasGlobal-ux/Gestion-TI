import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/pdf_style.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future responsibaTemp(context, Usuario data, String especificaciones, String mm, String sn) async {
  var time = DateTime.now();
  var day = time.day.toString().length == 1 ? "0${time.day}" : "${time.day}";
  var month = time.month.toString().length == 1 ? "0${time.month}" : "${time.month}";
  final fecha = "Ciudad de México a $day del $month del ${time.year}     ";

  List<int> bytes = [];
  PdfDocument document = PdfDocument();

  final page = document.pages.add();
  PdfGrid grid = PdfGrid();

  grid.columns.add(count: 6);

  //TITULO INICIO DE DOCUMENTO
  PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].columnSpan = 6;
  celdaDato(headerRow, 0, "CARTA RESPONSIVA DE PERIFERICO", 18);

  PdfGridRow rowDate = grid.rows.add();
  rowDate.cells[0].columnSpan = 6;
  celdaValorFecha(rowDate, 0, fecha);

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow rowSalto1 = grid.rows.add();
  saltoDeCelda(rowSalto1, 6);

  //DATOS COLABORADOS
  PdfGridRow rowDatos = grid.rows.add();
  rowDatos.cells[0].columnSpan = 6;
  celdaDato(rowDatos, 0, "DATOS DEL COLABORADOR", 10);

  PdfGridRow rowUser = grid.rows.add();
  rowUser.cells[0].columnSpan = 2;
  celdaDato(rowUser, 0, "USUARIO:", 8);
  rowUser.cells[2].columnSpan = 4;
  celdaValor(rowUser, 2, "${data.nombres} ${data.apellidos}");

  PdfGridRow rowEmail = grid.rows.add();
  rowEmail.cells[0].columnSpan = 2;
  celdaDato(rowEmail, 0, "CORREO:", 8);
  rowEmail.cells[2].columnSpan = 4;
  celdaValor(rowEmail, 2, data.correo!);

  PdfGridRow rowArea = grid.rows.add();
  rowArea.cells[0].columnSpan = 2;
  celdaDato(rowArea, 0, "AREA:", 8);
  rowArea.cells[2].columnSpan = 4;
  celdaValor(rowArea, 2, data.area);

  PdfGridRow rowSede = grid.rows.add();
  rowSede.cells[0].columnSpan = 2;
  celdaDato(rowSede, 0, "SEDE:", 8);
  rowSede.cells[2].columnSpan = 4;
  celdaValor(rowSede, 2, data.sede);

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow rowSalto2 = grid.rows.add();
  saltoDeCelda(rowSalto2, 6);

  PdfGridRow rowtexto1 = grid.rows.add();
  rowtexto1.cells[0].columnSpan = 6;
  celdaValor(rowtexto1, 0, """\n
Por medio de la presente, me comprometo a hacerme cargo y responsable del Periferico descrito a continuación,\n el cual me ha sido asignado para su uso y beneficio, reconociendo que este es propiedad del Corporativo RJG.
\n
""");

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow rowSalto3 = grid.rows.add();
  saltoDeCelda(rowSalto3, 6);

  //DATOS COLABORADOS
  PdfGridRow rowPerifericoH = grid.rows.add();
  rowPerifericoH.cells[0].columnSpan = 6;
  celdaDato(rowPerifericoH, 0, "PERIFERICO", 10);

  PdfGridRow rowPeriferico = grid.rows.add();
  rowPeriferico.cells[0].columnSpan = 2;
  celdaDato(rowPeriferico, 0, "ESPECIFICACIONES:", 8);
  rowPeriferico.cells[2].columnSpan = 4;
  celdaValor(rowPeriferico, 2, especificaciones);

  PdfGridRow rowMarcaModelo = grid.rows.add();
  rowMarcaModelo.cells[0].columnSpan = 2;
  celdaDato(rowMarcaModelo, 0, "MARCA / MODELO:", 8);
  rowMarcaModelo.cells[2].columnSpan = 4;
  celdaValor(rowMarcaModelo, 2, mm);

  PdfGridRow rowSN = grid.rows.add();
  rowSN.cells[0].columnSpan = 2;
  celdaDato(rowSN, 0, "SN:", 8);
  rowSN.cells[2].columnSpan = 4;
  celdaValor(rowSN, 2, sn);

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow rowSalto4 = grid.rows.add();
  saltoDeCelda(rowSalto4, 6);

  PdfGridRow rowtexto2 = grid.rows.add();
  rowtexto2.cells[0].columnSpan = 6;
  celdaValor(rowtexto2, 0, """\n
Me coprometo a utilizar el Periferico exclusivamente para los fines relacionados con las actividades que se me\n asignen y tareas asignadas dentro de RJG. Acepto no darle un uso indebido ni destinarlo a\n fines distintos para los cuales se me asigno.

Asimismo, me hago responsable de matener el Periferico en buen estado, reportar de inmediato cualquier falla, daño\n o mal funcinamiento que este pueda presentar, y devolver el Periferico en las mismas condiciones en que fue recibido,\n exceptuando el desgaste natural por su uso adecuado.

En caso de pérdida o daño por negligencia, me comprometo a reponer el Periferico o informacion o a cubrir\n los costos de reparacion hasta la total satisfaccion de RJG.

Este compromizo estara vigente hasta que el Periferico sea devuelto
\n
""");

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow rowSalto5 = grid.rows.add();
  saltoDeCelda(rowSalto5, 6);

  PdfGridRow rowFirma = grid.rows.add();
  rowFirma.cells[0].columnSpan = 2;
  celdaDato(rowFirma, 0, "FIRMA:", 8);
  rowFirma.cells[2].columnSpan = 4;
  celdaValor(rowFirma, 2, " ");

  grid.draw(page: page, bounds: const Rect.fromLTWH(0, 12, 0, 0));
  bytes = await document.save();
  document.dispose();
  saveFile(
    bytes,
    "${data.area}_${data.nombres}_${data.snEquipo}",
    "RESPONSIVAS",
    context,
    "pdf",
  );
}
