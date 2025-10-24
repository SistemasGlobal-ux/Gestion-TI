import 'dart:ui';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/pdf_style.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future pdfMantP(documento, Usuario usuario, Equipo equipo, context) async {
  TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;

  List<int> bytes = [];
  PdfDocument document = PdfDocument();

  final page = document.pages.add();
  PdfGrid grid = PdfGrid();

  grid.columns.add(count: 12);

  //TITULO INICIO DE DOCUMENTO
  PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].columnSpan = 12;
  celdaDato(headerRow, 0, "MANTENIMIENTO PREVENTIVO DE EQUIPO DE COMPUTO", 18);
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
  //FILA 2 COLABORADOR
  PdfGridRow row3 = grid.rows.add();
  row3.cells[0].columnSpan = 3;
  celdaDato(row3, 0, "Fecha programada:", 8);
  row3.cells[3].columnSpan = 3;
  celdaValor(row3, 3, "     /                    /");
  row3.cells[6].columnSpan = 3;
  celdaDato(row3, 6, "Tiempo estimado:", 8);
  row3.cells[9].columnSpan = 3;
  celdaValor(row3, 9, "De 20 a 30 minutos");

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
  //
  PdfGridRow row11 = grid.rows.add();
  row11.cells[0].columnSpan = 12;
  celdaDato(row11, 0, "TIPO DE MANTENIMIENTO", 10);
  PdfGridRow row12 = grid.rows.add();
  row12.cells[0].columnSpan = 12;
  celdaDato(
    row12,
    0,
    "Por favor marque las opciones correspondientes (TECNICO RESPONSABLE):",
    10,
  );
  PdfGridRow row13 = grid.rows.add();
  row13.cells[0].columnSpan = 11;
  celdaValorStart(
    row13,
    0,
    "  Preventivo general: Revisión básica de hardware y software para detectar y prevenir fallas.",
  );
  celdaValor(row13, 11, "[       ]");

  PdfGridRow row14 = grid.rows.add();
  row14.cells[0].columnSpan = 11;
  celdaValorStart(
    row14,
    0,
    "  Limpieza interna: Retiro de polvo en componentes, cambio de pasta térmica, etc.",
  );
  celdaValor(row14, 11, "[       ]");
  PdfGridRow row15 = grid.rows.add();
  row15.cells[0].columnSpan = 11;
  celdaValorStart(
    row15,
    0,
    "  Optimización de software: Mejora del rendimiento eliminando archivos innecesarios (TEMP).",
  );
  celdaValor(row15, 11, "[       ]");
  PdfGridRow row16 = grid.rows.add();
  row16.cells[0].columnSpan = 11;
  celdaValorStart(
    row16,
    0,
    "  Actualizaciones: Instalación de parches y actualizaciones para seguridad y estabilidad del equipo.",
  );
  celdaValor(row16, 11, "[       ]");
  PdfGridRow row17 = grid.rows.add();
  row17.cells[0].columnSpan = 11;
  celdaValorStart(row17, 0, "  Otro:");
  celdaValor(row17, 11, "[       ]");

  PdfGridRow row18 = grid.rows.add();
  row18.cells[0].columnSpan = 12;
  celdaDato(row18, 0, "RESULTADO DEL CONTACTO CON USUARIO", 10);
  PdfGridRow row19 = grid.rows.add();
  row19.cells[0].columnSpan = 12;
  celdaDato(
    row19,
    0,
    "Por favor marque la opción correspondiente (USUARIO):",
    10,
  );
  PdfGridRow row20 = grid.rows.add();
  row20.cells[0].columnSpan = 11;
  celdaValorStart(row20, 0, "  Acepté y se realizó el mantenimiento");
  celdaValor(row20, 11, "[       ]");
  PdfGridRow row21 = grid.rows.add();
  row21.cells[0].columnSpan = 11;
  celdaValorStart(row21, 0, "  Rechacé el mantenimiento en esta ocasión");
  celdaValor(row21, 11, "[       ]");

  PdfGridRow row22 = grid.rows.add();
  row22.cells[0].columnSpan = 12;
  celdaValorStart(
    row22,
    0,
    "  Acordé reprogramarlo para el día __________ del __________ del __________",
  );

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row23 = grid.rows.add();
  saltoDeCelda(row23, 12);

  //OBSERVACIONES
  PdfGridRow row24 = grid.rows.add();
  row24.cells[0].columnSpan = 12;
  celdaDato(row24, 0, "OBSERVACIONES", 10);
  //FILA 1 OBSERVACIONES
  PdfGridRow row25 = grid.rows.add();
  row25.cells[0].columnSpan = 12;
  celdaValor(
    row25,
    0,
    """Declaro haber sido informado(a) del mantenimiento preventivo programado.
      Nota: El mantenimiento solo podrá reprogramarse hasta dos veces. En caso de no poder realizarse en la segunda programación, se considerará como rechazado y se reagendará hasta el siguiente trimestre.""",
  );
  PdfGridRow row26 = grid.rows.add();
  row26.cells[0].columnSpan = 12;
  celdaDato(
    row26,
    0,
    "Por favor marque la opción correspondiente (USUARIO):",
    10,
  );
  PdfGridRow row27 = grid.rows.add();
  row27.cells[0].columnSpan = 11;
  celdaValorStart(row27, 0, "  Acepté y se realizó el mantenimiento");
  celdaValor(row27, 11, "[       ]");
  PdfGridRow row28 = grid.rows.add();
  row28.cells[0].columnSpan = 11;
  celdaValorStart(row28, 0, "  Rechacé el mantenimiento en esta ocasión");
  celdaValor(row28, 11, "[       ]");

  PdfGridRow row29 = grid.rows.add();
  row29.cells[0].columnSpan = 12;
  celdaValorStart(
    row29,
    0,
    "  Acordé reprogramarlo para el día __________ del __________ del __________",
  );

  //ESPACIO VACIO SALTO DE LINEA
  PdfGridRow row30 = grid.rows.add();
  saltoDeCelda(row30, 12);

  //ENTREGA O RECEPCCION DE EQUIPO
  PdfGridRow row31 = grid.rows.add();
  row31.cells[0].columnSpan = 12;
  celdaDato(row31, 0, "FIRMAS DE CONFORMIDAD", 10);
  //FILA 1 ENTREGA DE EQUIPO
  PdfGridRow row32 = grid.rows.add();
  celdaDato(row32, 0, " ", 8);
  row32.cells[0].style.borders = onliLTB;
  row32.cells[1].columnSpan = 5;
  celdaDato(row32, 1, "USUARIO", 8);
  row32.cells[1].style.borders = onliRTB;
  celdaDato(row32, 6, " ", 8);
  row32.cells[6].style.borders = onliLTB;
  row32.cells[7].columnSpan = 5;
  celdaDato(row32, 7, "TECNICO RESPONSABLE", 8);
  row32.cells[7].style.borders = onliRTB;

  //FILA 2 ENTREGA DE EQUIPO
  PdfGridRow row33 = grid.rows.add();
  celdaDato(row33, 0, "NOMBRE", 8);
  row33.cells[1].columnSpan = 5;

  celdaValor(row33, 1, "${usuario.nombres} ${usuario.apellidos}");
  celdaDato(row33, 6, "NOMBRE", 8);
  row33.cells[7].columnSpan = 5;
  celdaValor(
    row33,
    7,
    "${tecnico.nombres} ${tecnico.apellidos}",
  );
  PdfGridRow row34 = grid.rows.add();
  celdaDato(row34, 0, "\n FIRMA \n ", 8);
  row34.cells[1].columnSpan = 5;
  celdaValor(row34, 1, " ");
  celdaDato(row34, 6, "\n FIRMA \n ", 8);
  row34.cells[7].columnSpan = 5;
  celdaValor(row34, 7, " ");
  //FILA 4 ENTREGA DE EQUIPO
  PdfGridRow row35 = grid.rows.add();
  celdaDato(row35, 0, "FECHA", 8);
  row35.cells[1].columnSpan = 5;
  celdaValor(row35, 1, "/                              /");
  celdaDato(row35, 6, "FECHA", 8);
  row35.cells[7].columnSpan = 5;
  celdaValor(row35, 7, "/                              /");

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
