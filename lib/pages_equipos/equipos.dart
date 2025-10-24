import 'package:application_sop/busqueda_delegates/custom_search_equipo.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/pages_equipos/equipos_detalle.dart';
import 'package:application_sop/pages_equipos/nuevo_equipo.dart';
import 'package:application_sop/services/fetch_data.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';

class PageEquipos extends StatefulWidget {
  const PageEquipos({super.key});

  @override
  State<PageEquipos> createState() => _PageEquiposState();
}

class _PageEquiposState extends State<PageEquipos> {
  late Future<List<Equipo>> equipos;

  @override
  void initState() {
    super.initState();
    equipos = fetchEquipos().then((lista) => ordenarEquiposPorEstado(lista));
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
                    final lista = await equipos;
                    showSearch(
                      // ignore: use_build_context_synchronously
                      context: context,
                      delegate: BusquedaEquipoDelegate(lista),
                    );
                  },
                  Icons.search,
                  "Busqueda",
                  compact,
                ),
                myResponsiveButton(() => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AgregarEquipo()),
                  ), Icons.add, "Agregar", compact),
                myResponsiveButton(
                  () async {
                    //exportEquiposToExcel(context, "Generando excel...");
                  },
                  Icons.import_export_sharp,
                  "Exportar",
                  compact,
                ),
              ],
            );
          },
        ),
      ),

      body: FutureBuilder<List<Equipo>>(
        future: equipos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay equipos disponibles.'));
          }
          return equiposAgrupados(snapshot.data!);
        },
      ),
    );
  }

  equiposAgrupados(List<Equipo> equipo) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(color: Colors.transparent, height: 5),
      itemCount: equipo.length,
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          decoration: BoxDecoration(
            color: myColor(equipo[i].estado!),
            borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ListTile(
              title: Text("${equipo[i].marca} ${equipo[i].modelo}", style: TextStyle(fontSize: 15)),
              subtitle: Text("${equipo[i].estado} - ${equipo[i].sede}", style: TextStyle(fontSize: 10)),
              onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
              builder:
              (_) => EquipoDetalle(equipo: equipo[i])
              ),
              );
              },
          ),
        );
      },
    );
  }
}
