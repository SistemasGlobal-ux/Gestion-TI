import 'package:application_sop/busqueda_delegates/custom_search_equipo.dart';
import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/services/fetch_data.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:application_sop/utils/cards.dart';
import 'package:flutter/material.dart';

class UsuarioDetalleScreen extends StatefulWidget {
  final Usuario usuario;

  const UsuarioDetalleScreen({super.key, required this.usuario});

  @override
  State<UsuarioDetalleScreen> createState() => _UsuarioDetalleScreenState();
}

class _UsuarioDetalleScreenState extends State<UsuarioDetalleScreen> {

    Equipo? equipo;
    late Future<List<Equipo>> futureEquipos;

   @override
  void initState() {
    super.initState();
    futureEquipos = fetchEquipos();
  }

  @override
  Widget build(BuildContext context) {
    final areaColor = myColor(widget.usuario.area);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.usuario.nombres} ${widget.usuario.apellidos}'),
        centerTitle: true,
        backgroundColor: areaColor,
        actions: [
          IconButton(
          onPressed: () {
          generarPdfBaja(context, "Generando PDF...", widget.usuario);
          Navigator.pop(context);
          },
          icon: Icon(Icons.delete_forever, color: Colors.red),
          tooltip: "Baja usuario",)
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de datos generales usuario
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: userCard(context, widget.usuario, areaColor)
                ),
              ],
            ),
Align(
  alignment: Alignment.center,
  child: Wrap(
    spacing: 16,
    children: [
      ElevatedButton.icon(
        icon: Icon(Icons.desktop_mac),
        label: Text('Asignar equipo(s)'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: () async {
                            final lista = await futureEquipos;
                            equipo = await showSearch(
                              // ignore: use_build_context_synchronously
                              context: context,
                              delegate: BusquedaEquipoDelegate(lista),
                            );
                            equipo!.numeroSerie!.isNotEmpty
                                ? {
                                  setState(() {}),
                                }
                                : {null};
                          },
      ),
      OutlinedButton.icon(
        icon: Icon(Icons.description_outlined),
        label: Text('Responsiva detallada'),
        onPressed: () {},
      ),
    ],
  ),
),
            // Título para equipos
            Text(
              'Equipo(s) asignado(s)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            widget.usuario.equipos!.isEmpty
                ? Text('No tiene equipos asignados.')
                : Column(
                    children: widget.usuario.equipos!
                        .map((equipo) => equipoAndUserCard(context, equipo, widget.usuario, areaColor))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }


}
