import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/modelo_1.dart';

Future pdfEntregaEquipo(Usuario usuario, Equipo equipo, context) async {
  pdfEquipo(
    "ACTA DE ENTREGA DE EQUIPO DE CÓMPUTO",
    "EQUIPO NUEVO PARA PERSONALIZAR",
    """

Certifico que los elementos detallados en el presente documento me han sido entregados para mi cuidado y 
custodia con el propósito de cumplir con las tareas y asignaciones propias de mi cargo,
siendo estos de mi única y exclusiva responsabilidad. Me comprometo a usar correctamente los recursos, 
y solo para los fines establecidos, a no instalar ni permitir la instalación de software por personal 
ajeno al grupo interno de trabajo de soporte de TI.

En caso de extravío, daño, o uso inadecuado del equipo me responsabilizo a pagar el costo de reparación 
o bien la reposición de este.

""",
    "FIRMAS DE CONFORMIDAD",
    "RECIBE",
    "ENTREGA",
    "Ingresos",
    usuario,
    equipo,
    context,
  );
}
