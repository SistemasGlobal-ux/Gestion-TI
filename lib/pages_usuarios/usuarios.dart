
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/pages_usuarios/nuevo_usuario.dart';
import 'package:application_sop/pages_usuarios/usuario_detalle.dart';
import 'package:application_sop/busqueda_delegates/custom_search_user.dart';
import 'package:application_sop/services/fetch_data.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';

class PageUsuarios extends StatefulWidget {
  const PageUsuarios({super.key});

  @override
  State<PageUsuarios> createState() => _PageUsuariosState();
}

class _PageUsuariosState extends State<PageUsuarios> {
  late Future<Map<String, List<Usuario>>?>? usuariosPorArea;

  @override
  void initState() {
    super.initState();
    usuariosPorArea = fetchUsuariosArea();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        title: LayoutBuilder(
          builder: (context, constraints) {
            bool compact = constraints.maxWidth < 500;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                myResponsiveButton(
                  () async {
                    final data = await usuariosPorArea;
                    final lista = data?.values.expand((u) => u).toList() ?? [];
                    showSearch(
                      // ignore: use_build_context_synchronously
                      context: context,
                      delegate: BusquedaUserDelegate(lista),
                    );
                  },
                  Icons.search,
                  "Busqueda",
                  compact,
                ),
                myResponsiveButton(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AgregarUsuario()),
                  ),
                  Icons.add,
                  "Agregar",
                  compact,
                ),
                myResponsiveButton(
                  (){}, //=> exportUsersToExcel(context, "Generando Excel..."),
                  Icons.import_export_sharp,
                  "Exportar",
                  compact,
                ),
              ],
            );
          },
        ),
      ),

      body: FutureBuilder<Map<String, List<Usuario>>?>(
        future: usuariosPorArea,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay usuarios disponibles.'));
          }
          // Ya tenemos el mapa de usuarios agrupado
          final usuariosPorArea = snapshot.data!;
          return usuariosAgrupados(usuariosPorArea);
        },
      ),
    );
  }

  usuariosAgrupados(Map<String, List<Usuario>> usuariosPorArea) {
    final areas = usuariosPorArea.keys.toList();
    return ListView.builder(
      itemCount: areas.length,
      itemBuilder: (context, index) {
        final area = areas[index];
        final usuarios = usuariosPorArea[area]!;

        return ExpansionTile(
          initiallyExpanded: true,
          title: Container(
            padding: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: myColor(area),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            height: 30,
            child: Text("$area - ${usuariosPorArea[area]?.length}"),
          ),
          children:
              usuarios.map((usuario) {
                return Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 10,
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(color: myColor(area),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${usuario.sede} - ${usuario.area}/${usuario.puesto}",
                        style: TextStyle(fontSize: 10)),
                        Text('${usuario.nombres} ${usuario.apellidos}',
                      style: TextStyle(fontSize: 13))
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => UsuarioDetalleScreen(usuario: usuario),
                        ),
                      );
                    },
                    
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
