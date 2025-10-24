import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/modelo_1.dart';

Future pdfCambioEquipo(Usuario usuario, Equipo equipo, context) async {
  pdfEquipo(
    "ACTA DE RECEPCIÓN DE EQUIPO DE CÓMPUTO",
    "RECEPCCIÓN DE EQUIPO DEBIDO A CAMBIO DE EQUIPO",
    """

Certifico que los elementos detallados en el presente documento me han sido entregados para mi cuidado y custodia, 
así como el manejo de información de forma adecuada por si se llegara a solicitar 
ya que el equipo se formateara de forma que se pueda brindar a otro usuario en algún futuro.

En caso de extravío, daño, o uso inadecuado del equipo me responsabilizo a 
pagar el costo de reparación o bien la reposición de este.


""",
    "FIRMAS DE CONFORMIDAD",
    "ENTREGA",
    "RECIBE",
    "Cambios",
    usuario,
    equipo,
    context,
  );
}
