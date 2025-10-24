

  import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/modelos%20pdfs/entrega_equipo_terceros.dart';
import 'package:application_sop/modelos%20pdfs/mant_correctivo.dart';
import 'package:application_sop/modelos%20pdfs/mant_preventivo.dart';
import 'package:application_sop/pages_usuarios/editar_usaurio.dart';
import 'package:application_sop/utils/copi_text.dart';
import 'package:flutter/material.dart';

Widget userCard(BuildContext context,Usuario usuario, Color areaColor){
  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    shadowColor: areaColor.withValues(alpha:0.5),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.person, size: 30, color: areaColor),
                      const SizedBox(width: 12),
                       Flexible(
                         child: Text(
                            maxLines: 1,
                            '${usuario.nombres} ${usuario.apellidos}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                       ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Editar usuario',
                  icon: Icon(Icons.edit, color: Colors.black),
                  //TODO: Agregar funcion para editar info del usuario
                  onPressed: () {
                    mostrarEditarUsuario(context, usuario);
                  })]),
                          Divider(height: 12),
                          CopiText(label: 'Operativa', value: usuario.operativa),
                          CopiText(label: 'Sede', value: usuario.sede),
                          CopiText(label: 'Ingreso', value: usuario.ingreso),
                          CopiText(label: 'Área', value: usuario.area),
                          CopiText(label: 'Puesto', value: usuario.puesto),
                          CopiText(label: 'Contacto', value: usuario.contacto, showIconAndAnimation: true),
                          CopiText(
                            label: 'Email',
                            value: usuario.correo!.isNotEmpty
                                ? usuario.correo!
                                : 'No asignado',
                            showIconAndAnimation: true,
                          ),
                          CopiText(label: 'Email-Pass', value: usuario.psw!, showIconAndAnimation: true),
                          CopiText(label: 'Estado', value: usuario.estado),
                          CopiText(label: 'Notas', value: usuario.notas),
                        ],
                      ),
                    ),
                  );
}

Widget equipoAndUserCard(BuildContext context, Equipo equipo,Usuario usuario, Color areaColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.computer, size: 30, color: areaColor),
                      const SizedBox(width: 12),
                       Flexible(
                         child: Text(
                            maxLines: 1,
                            '${equipo.marca} ${equipo.modelo}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                       ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Eliminar equipo',
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    // TODO, Agregar funcion para eliminar equipo asignado
                  },
                ),
              ],
            ),
            const Divider(height: 20),

            // Datos principales
            CopiText(label: "NS", value: equipo.numeroSerie!, showIconAndAnimation: true),
            const SizedBox(height: 8),
            CopiText(label: "Usuario NAS", value: equipo.nas!),
            CopiText(label: "pass nas", value: "N_marcelo.1"),
            const SizedBox(height: 12),
            Text('Entregado: ${equipo.fechaEntrega}'),
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: "PDF Ingreso",
                  icon: Icon(Icons.picture_as_pdf, color: areaColor),
                  onPressed: () {
                    generarPdfIngreso(context, usuario, "Generando PDF...", 0);
                  },
                ),
                IconButton(
                  tooltip: "PDF Preventivo",
                  icon: Icon(Icons.build_circle, color: Colors.green.shade700),
                  onPressed: () {
                    pdfMantPrevEquipo(usuario, equipo, context);
                  },
                ),
                IconButton(
                  tooltip: "PDF Correctivo",
                  icon: Icon(Icons.home_repair_service_outlined, color: Colors.orange.shade700),
                  onPressed: () {
                    pdfMantCorretEquipo(usuario, equipo, context);
                  },
                ),
                IconButton(
                  tooltip: "Hoja responsiva terceros",
                  icon: Icon(Icons.assignment_ind_outlined, color: Colors.teal.shade700),
                  onPressed: () {
                    pdfEntregaEquipoTerceros(usuario, equipo, context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget equipoCard(BuildContext context, Equipo equipo, Color estadoColor){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.computer, size: 30, color: estadoColor),
                      const SizedBox(width: 12),
                       Flexible(
                         child: Text(
                            maxLines: 1,
                            '${equipo.marca} ${equipo.modelo}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                       ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Editar equipo',
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            const Divider(height: 20),
            // Datos principales
            Text("Empresa"),
            CopiText(label: "Operativa", value: equipo.operativa!),
            CopiText(label: "Sede", value: equipo.sede!),
            const Divider(height: 10),
            Text("Especificaciones del equipo"),
            CopiText(label: "Fecha de recepcion", value: equipo.recepcion!),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Tipo de equipo", value: equipo.tipo!),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Numero de serie", value: equipo.numeroSerie!, showIconAndAnimation: true),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Marca", value: equipo.marca!, showIconAndAnimation: true),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Modelo", value: equipo.modelo!, showIconAndAnimation: true),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Procesador", value: "${equipo.procesador} ${equipo.generacion}"),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Disco principal", value: equipo.discoPrincipal!),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Disco secundario", value: equipo.discoSecundario!),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Memoria RAM", value: equipo.ram!),
            const Divider(height: 6, color: Colors.transparent),
            CopiText(label: "Sistema Operativo", value: equipo.sistemaOperativo!),
            const Divider(height: 10),
            CopiText(label: "Usuario", value: equipo.idUser!, showIconAndAnimation: true),
            CopiText(label: "Fecha de entrega", value: equipo.fechaEntrega!),
            const Divider(height: 10),
            Text("Información adicional"),
            CopiText(label: "Notas", value: equipo.notas!),
            const Divider(height: 4),
            //// Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: "asignar equipo",
                  icon: Icon(Icons.assignment_ind_outlined, color: Colors.teal.shade700),
                  onPressed: () {
                  },
                ),
              ],
            ),
            ////
          ],
        ),
      ),
    );
  }