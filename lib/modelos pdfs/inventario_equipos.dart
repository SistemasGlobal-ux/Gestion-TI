
import 'dart:ui';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/modelos%20pdfs/pdf_style.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> inventarioEquiposPDF(List<Equipo> equipos, context) async {
  // Crear documento
  PdfDocument document = PdfDocument();
  // Agregar página
  final page = document.pages.add();
  // Crear tabla
  PdfGrid grid = PdfGrid();
  grid.columns.add(count: 12);
  // Título
  PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].columnSpan = 12;
  celdaDato(headerRow, 0, "INVENTARIO EQUIPOS", 18);
  // Fila de títulos
  PdfGridRow rowT = grid.rows.add();
    rowT.cells[0].columnSpan = 2;
    celdaDato(rowT, 0, "RECEPCION", 8);
    rowT.cells[2].columnSpan = 2;
    celdaDato(rowT, 2, "ESTADO", 8);
    rowT.cells[4].columnSpan = 2;
    celdaDato(rowT, 4, "TIPO", 8);
    rowT.cells[6].columnSpan = 2;
    celdaDato(rowT, 6, "MARCA", 8);
    rowT.cells[8].columnSpan = 2;
    celdaDato(rowT, 8, "MODELO", 8);
    rowT.cells[10].columnSpan = 2;
    celdaDato(rowT, 10, "NUMERO DE SERIE", 8);

  // Filas de datos
  for (var equipo in equipos) {
    PdfGridRow row = grid.rows.add();
    row.cells[0].columnSpan = 2;
    celdaValor(row, 0, equipo.recepcion ?? '~');
    row.cells[2].columnSpan = 2;
    celdaValor(row, 2, equipo.estado ?? '~');
    row.cells[4].columnSpan = 2;
    celdaValor(row, 4, equipo.tipo ?? '~');
    row.cells[6].columnSpan = 2;
    celdaValor(row, 6, equipo.marca ?? '~');
    row.cells[8].columnSpan = 2;
   celdaValor(row, 8, equipo.modelo ?? '~');
    row.cells[10].columnSpan = 2;
    celdaValor(row, 10, equipo.numeroSerie ?? '~');
  }

  // Dibujar tabla en la página
  grid.draw(page: page, bounds: Rect.fromLTWH(0, 0, 0, 0));
  // Guardar PDF en memoria
  List<int> bytes = await document.save();
  document.dispose();
  // Guardar archivo temporal y abrirlo
    saveFile(
    bytes,
    "inventario_Equipos",
    "inventario",
    context,
    "pdf",
  );
}
