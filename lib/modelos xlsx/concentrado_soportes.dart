

import 'package:application_sop/maps/soportes.dart';
import 'package:application_sop/modelos%20xlsx/styles_excel.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future excelCSoportes(context, List<Soportes> soportes) async {
  try {
    final Workbook libro = Workbook();
    Worksheet sheet = libro.worksheets[0];

    int numeroInicial = 2;

    for (var i = 0; i < soportes.length; i++){

      void setCell(String col, int n, String value) {
      sheet.getRangeByName('$col$n').setText(value);
      sheet.getRangeByName('$col$n').cellStyle = styleNormal(libro);
      sheet.autoFitColumn(n);
      }

      // Headers solo 1 vez
      if (i == 0) {
        final headers = headerSoportes();
        for (int h = 0; h < headers.length; h++) {
          final col = String.fromCharCode(65 + h); // A, B, C, ...
          final celda = sheet.getRangeByName('$col${1}');
          celda.setText(headers[h]);
          celda.cellStyle = globalStyleH1(libro);
        }
      }

      setCell('A', i + numeroInicial,soportes[i].fechaCierre);
      setCell('B', i + numeroInicial,soportes[i].nombreUsuario!);
      setCell('C', i + numeroInicial,soportes[i].problema);
      setCell('D', i + numeroInicial,soportes[i].solucion);
      setCell('E', i + numeroInicial,soportes[i].fechaInicio);

    }

    final List<int> bytes = libro.saveAsStream();
    libro.dispose();
    saveFile(bytes, "Concentrado Soportes", "INVENTARIO", context, "xlsx");

  } catch (e) {
    LoggerService.write("Error al generar Excel Soportes: $e");
  }
}