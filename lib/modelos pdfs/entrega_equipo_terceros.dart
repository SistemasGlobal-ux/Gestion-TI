

import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/modelo_1.dart';

Future pdfEntregaEquipoTerceros(Usuario usuario, Equipo equipo, context) async {
  pdfEquipo(
    "ACTA DE ENTREGA DE EQUIPO A TERCEROS",
    "ENTREGA A PERSONA AUTORIZADA",
    """

Por medio de la presente se hace constar que el equipo descrito en este documento ha sido entregado a un tercero debidamente autorizado por el colaborador ${usuario.nombres} ${usuario.apellidos}, para su traslado y custodia temporal.

Se establece que la responsabilidad del equipo continúa recayendo en el colaborador titular, quien deberá garantizar su correcto uso, resguardo y eventual devolución en las mismas condiciones en las que le fue entregado originalmente.

La persona que recibe este equipo actúa únicamente como enlace autorizado para su traslado.

""",
    "FIRMAS DE CONFORMIDAD",
    "RECIBE",
    "ENTREGA",
    "Terceros",
    usuario,
    equipo,
    context,
    mostrarNombreReceptor: false,
  );
}
