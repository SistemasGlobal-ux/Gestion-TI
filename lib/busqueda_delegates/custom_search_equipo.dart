//ignore_for_file: file_names, non_constant_identifier_names, avoid_types_as_parameter_names, no_leading_underscores_for_local_identifiers, unused_field, use_build_context_synchronously

import 'package:application_sop/maps/equipos.dart';
//import 'package:application_sop/pages_equipos/equipos_detalle.dart';
import 'package:flutter/material.dart';

class BusquedaEquipoDelegate extends SearchDelegate<Equipo> {
  List<Equipo> equipo;
  List<Equipo> filtro = [];

  BusquedaEquipoDelegate(this.equipo);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.backspace_outlined, color: Colors.black87),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
          context,
          Equipo(
            id: null,
            numeroSerie: "",
            nas: "",
            fechaEntrega: "",
            hojaEntrega: "",
            notas: "",
            baja: "",
            detalleBaja: "",
            discoPrincipal: "",
            discoSecundario: "",
            estado: "",
            generacion: "",
            marca: "",
            modelo: "",
            operativa: "",
            procesador: "",
            ram: "",
            recepcion: "",
            sede: "",
            sistemaOperativo: "",
            tipo: "",
          ),
        );
      },
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Equipo> filtro =
        equipo.where((Equipo e) {
          var d = e.numeroSerie! + e.estado!;
          return d.toUpperCase().contains(query.toUpperCase());
        }).toList();

    // Ordena para que los que están en "ESTOCK" salgan primero
    filtro.sort((a, b) {
      if (a.estado == "STOCK" && b.estado != "STOCK") return -1;
      if (a.estado != "STOCK" && b.estado == "STOCK") return 1;
      return a.numeroSerie!.compareTo(
        b.numeroSerie!,
      ); // orden alfabético si mismos estados
    });

    return ListView.builder(
      itemCount: filtro.length,
      itemBuilder:
          (_, i) => Container(
            color: Colors.red,
            child: ListTile(
              leading: const Icon(
                Icons.desktop_mac,
                color: Colors.black87,
                size: 30,
              ),
              title: Text(filtro[i].numeroSerie!),
              subtitle: Text(filtro[i].estado!),
              //TODO: agregar opccion de ver card o seleccioanr equipo para asignar// checar log, no se registro usurio en equipo
              onTap:() => //Navigator.push(context, MaterialPageRoute(builder:(_) => EquipoDetalle(equipo: filtro[i])))
                close(context, filtro[i])
            ),
          ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Equipo> filtro =
        equipo.where((Equipo e) {
          var d = e.numeroSerie! + e.estado!;
          return d.toUpperCase().contains(query.toUpperCase());
        }).toList();

    // Ordena para que los que están en "STOCK" salgan primero
    filtro.sort((a, b) {
      if (a.estado == "STOCK" && b.estado != "STOCK") return -1;
      if (a.estado != "STOCK" && b.estado == "STOCK") return 1;
      return a.numeroSerie!.compareTo(b.numeroSerie!);
    });

    return ListView.separated(
      separatorBuilder:
          (context, i) => const Divider(color: Colors.black, height: 3),
      itemCount: filtro.length,
      itemBuilder:
          (_, i) => Container(
            margin: const EdgeInsets.all(5),
            color:
                filtro[i].estado == "ENTREGADO"
                    ? Colors.greenAccent
                    : filtro[i].estado == "STOCK"
                    ? Colors.yellowAccent
                    : Colors.redAccent,
            child: ListTile(
              leading: const Icon(
                Icons.desktop_mac,
                color: Colors.black87,
                size: 30,
              ),
              title: Text(filtro[i].numeroSerie!),
              subtitle: Text(filtro[i].estado!),
              onTap:
                () => //Navigator.push(context, MaterialPageRoute(builder:(_) => EquipoDetalle(equipo: filtro[i])))
                close(context, filtro[i])
            ),
          ),
    );
  }
}
