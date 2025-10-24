import 'package:application_sop/maps/correos.dart';
import 'package:application_sop/modelos%20xlsx/styles_excel.dart';
import 'package:application_sop/utils/safe_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future excelEmails(List<Correos> correo, context) async {
  try {
    final Workbook libro = Workbook();
    Worksheet sheet = libro.worksheets[0];

    for (var i = 0; i < correo.length; i++) {
      //
      sheet.getRangeByName('A1').setText("LICENCIAS");
      sheet.getRangeByName('A1').cellStyle = globalStyleH1(libro);
      sheet.getRangeByName('A${i + 2}').setText(correo[i].id.toString());
      sheet.getRangeByName('A${i + 2}').cellStyle = styleNormal(libro);

      //
      sheet.getRangeByName('B1').setText("USUARIO/ORGANIZACION");
      sheet.getRangeByName('B1').cellStyle = globalStyleH1(libro);
      sheet
          .getRangeByName('B${i + 2}')
          .setText("${correo[i].asignacion}${correo[i].dominio}");
      sheet.getRangeByName('B${i + 2}').cellStyle = styleNormal(libro);

      //
      sheet.getRangeByName('C1').setText("CONTRASEÑA");
      sheet.getRangeByName('C1').cellStyle = globalStyleH1(libro);
      sheet.getRangeByName('C${i + 2}').setText(correo[i].passw);
      sheet.getRangeByName('C${i + 2}').cellStyle = styleNormal(libro);

      //
      sheet.getRangeByName('D1').setText("NOTAS");
      sheet.getRangeByName('D1').cellStyle = globalStyleH1(libro);
      sheet.getRangeByName('D${i + 2}').setText(correo[i].notas);
      sheet.getRangeByName('D${i + 2}').cellStyle = styleNormal(libro);

      //E,F,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y
    }

    final List<int> bytes = libro.saveAsStream();
    libro.dispose();
    saveFile(bytes, "Cuentas365", "INVENTARIO", context, "xlsx");
  } catch (e) {
    null;
  }
}
