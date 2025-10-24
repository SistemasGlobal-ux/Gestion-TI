import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/modelo_3.dart';

Future pdfMantCorretEquipo(Usuario usuario, Equipo equipo, context) async {
  pdfMantC("correctivo", usuario, equipo, context);
}
