
import 'dart:ui';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/pdf_style.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> inventarioUsuariosPDF(List<Usuario> usuarios, context) async {
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
  celdaDato(headerRow, 0, "INVENTARIO USUARIOS", 18);
  // Fila de títulos
  PdfGridRow rowT = grid.rows.add();
    rowT.cells[0].columnSpan = 2;
    celdaDato(rowT, 0, "AREA", 8);
    rowT.cells[2].columnSpan = 2;
    celdaDato(rowT, 2, "NOMBRE", 8);
    rowT.cells[4].columnSpan = 2;
    celdaDato(rowT, 4, "APELLIDO", 8);
    rowT.cells[6].columnSpan = 3;
    celdaDato(rowT, 6, "CORREO", 8);
    rowT.cells[9].columnSpan = 3;
    celdaDato(rowT, 9, "EQUIPO(S)", 8);

  // Filas de datos
  for (var usuarios in usuarios) {
    PdfGridRow row = grid.rows.add();
    row.cells[0].columnSpan = 2;
    celdaValor(row, 0, usuarios.area);
    row.cells[2].columnSpan = 2;
    celdaValor(row, 2, usuarios.nombres);
    row.cells[4].columnSpan = 2;
    celdaValor(row, 4, usuarios.apellidos);
    row.cells[6].columnSpan = 3;
    celdaValor(row, 6, usuarios.correo!);
    row.cells[9].columnSpan = 3;
    celdaValor(row, 9, usuarios.snEquipo);
  }

  // Dibujar tabla en la página
  grid.draw(page: page, bounds: Rect.fromLTWH(0, 0, 0, 0));
  // Guardar PDF en memoria
  List<int> bytes = await document.save();
  document.dispose();
  // Guardar archivo temporal y abrirlo
    saveFile(
    bytes,
    "inventario_Usuarios",
    "inventario",
    context,
    "pdf",
  );
}
