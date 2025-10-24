import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/modelo_2.dart';

Future pdfMantPrevEquipo(Usuario usuario, Equipo equipo, context) async {
  pdfMantP("preventivo", usuario, equipo, context);
}
