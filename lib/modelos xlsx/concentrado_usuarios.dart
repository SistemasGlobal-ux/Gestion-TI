import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20xlsx/styles_excel.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future excelUsuarios(List<Usuario> usuarios, String estado, context) async {
   try {
    final Workbook libro = Workbook();
    Worksheet sheet = libro.worksheets[0];

    int numeroInicial = 2;

    
    usuarios.sort((a, b) => a.area.compareTo(b.area));

    for (var i = 0; i < usuarios.length; i++) {

      void setCell(String col, int n, String value) {
      sheet.getRangeByName('$col$n').setText(value);
      sheet.getRangeByName('$col$n').cellStyle = styleColorA(libro, usuarios[i].area);
      sheet.autoFitColumn(n);
      }

      // Headers solo 1 vez
      if (i == 0) {
        final headers = headersUsuarios();
        for (int h = 0; h < headers.length; h++) {
          final col = String.fromCharCode(65 + h); // A, B, C, ...
          final celda = sheet.getRangeByName('$col${1}');
          celda.setText(headers[h]);
          celda.cellStyle = globalStyleH1(libro);
        }
      }

      setCell('A', i + numeroInicial,usuarios[i].estado);
      setCell('B', i + numeroInicial,usuarios[i].area);
      setCell('C', i + numeroInicial,usuarios[i].puesto);
      setCell('D', i + numeroInicial,usuarios[i].nombres);
      setCell('E', i + numeroInicial,usuarios[i].apellidos);
      setCell('F', i + numeroInicial,usuarios[i].contacto);
      setCell('G', i + numeroInicial,usuarios[i].correo!);
      setCell('H', i + numeroInicial,usuarios[i].psw!);

      setCell('J', i + numeroInicial,"N_marcelo.1");
      setCell('K', i + numeroInicial,usuarios[i].notas);

      for (var e = 0; e < usuarios[i].equipos!.length; e++) {
        if (usuarios[i].equipos!.length > 1) {
        setCell('J', i + numeroInicial + 1,"EQUIPO ADICIONAL:");
        setCell('K', i + numeroInicial + 1,usuarios[i].nombres);
        }
        
        setCell('I', i + numeroInicial,usuarios[i].equipos![e].nas!);
        setCell('L', i + numeroInicial,usuarios[i].equipos![e].tipo!);
        setCell('M', i + numeroInicial,usuarios[i].equipos![e].numeroSerie!);
        setCell('N', i + numeroInicial,usuarios[i].equipos![e].marca!);
        setCell('O', i + numeroInicial,usuarios[i].equipos![e].modelo!);
        setCell('P', i + numeroInicial,"${usuarios[i].equipos![e].procesador!} ${usuarios[i].equipos![e].generacion}");
        setCell('Q', i + numeroInicial,usuarios[i].equipos![e].discoPrincipal!);
        setCell('R', i + numeroInicial,usuarios[i].equipos![e].discoSecundario!);
        setCell('S', i + numeroInicial,usuarios[i].equipos![e].ram!);
        setCell('T', i + numeroInicial,usuarios[i].equipos![e].sistemaOperativo!);
        
        e == usuarios[i].equipos!.length - 1 ? null : numeroInicial = numeroInicial + 1;
      }
    }

    final List<int> bytes = libro.saveAsStream();
    libro.dispose();
    saveFile(bytes, "Usuarios $estado", "INVENTARIO", context, "xlsx");
  } catch (e) {
    LoggerService.write("Error al generar Excel Usuarios: $e");
  }
}
