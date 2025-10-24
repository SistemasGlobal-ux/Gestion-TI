import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20xlsx/styles_excel.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future excelEquipos(List<Equipo> equipos, List<Usuario> usuarios, context) async {

  try {
    final Workbook libro = Workbook();
    Worksheet sheet = libro.worksheets[0];
    int numeroInicial = 2;

    for ( var i = 0; i < equipos.length; i++ ){

      void setCell(String col, int n, String value) {
      sheet.getRangeByName('$col$n').setText(value);
      sheet.getRangeByName('$col$n').cellStyle = styleColorA(libro, equipos[i].estado);
      sheet.autoFitColumn(n);
      }

    // Headers solo 1 vez
    if(i == 0){
    List headers = headerEquipos();
    for (int h = 0; h < headers.length; h++) {
      final col = String.fromCharCode(65 + h); // A, B, C, ...
      final celda = sheet.getRangeByName('$col${1}');
      celda.setText(headers[h]);
      celda.cellStyle = globalStyleH1(libro);
    }
    }
    
    // Buscar el nombre del usuario asignado
    final usuarioAsignado = usuarios.firstWhere((u) => u.id == equipos[i].idUser,orElse: () => Usuario(operativa:"~", sede:"~", ingreso:"~", area:"~", puesto:"~", nombres:"~", apellidos:"", contacto:"~", notas:"~", snEquipo:"~", estado:"~", baja:"~"), // Usuario "vacío" si no hay coincidencia
);

    setCell('A', i + numeroInicial,equipos[i].recepcion!);
    setCell('B', i + numeroInicial,equipos[i].estado!);
    setCell('C', i + numeroInicial,equipos[i].sede!);
    setCell('D', i + numeroInicial, "${usuarioAsignado.nombres} ${usuarioAsignado.apellidos}");
    setCell('E', i + numeroInicial, usuarioAsignado.area);
    setCell('F', i + numeroInicial,equipos[i].numeroSerie!);
    setCell('G', i + numeroInicial,equipos[i].tipo!);
    setCell('H', i + numeroInicial,equipos[i].marca!);
    setCell('I', i + numeroInicial,equipos[i].modelo!);
    setCell('J', i + numeroInicial,"${equipos[i].procesador} ${equipos[i].generacion}");
    setCell('K', i + numeroInicial,equipos[i].discoPrincipal!);
    setCell('L', i + numeroInicial,equipos[i].discoSecundario!);
    setCell('M', i + numeroInicial,equipos[i].ram!);
    setCell('N', i + numeroInicial,equipos[i].sistemaOperativo!);
    setCell('O', i + numeroInicial,equipos[i].nas!);
    setCell('P', i + numeroInicial,equipos[i].fechaEntrega!);
    setCell('Q', i + numeroInicial,equipos[i].hojaEntrega!);
    setCell('R', i + numeroInicial,equipos[i].notas!);
    setCell('S', i + numeroInicial,equipos[i].baja!);
    setCell('T', i + numeroInicial,equipos[i].detalleBaja!);
    }

    final List<int> bytes = libro.saveAsStream();
    libro.dispose();
    saveFile(bytes, "Concentrado Equipos", "INVENTARIO", context, "xlsx");
  } catch (e) {
    LoggerService.write("Error al generar Excel Equipos: $e");
  }

}
