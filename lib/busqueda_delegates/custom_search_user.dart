// ignore_for_file: non_constant_identifier_names

import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/pages_usuarios/usuario_detalle.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:flutter/material.dart';


class BusquedaUserDelegate extends SearchDelegate<Usuario> {
  List<Usuario?> user;
  List<Usuario?> filtro = [];
  final bool mostrarDetalle;

  BusquedaUserDelegate(this.user, {this.mostrarDetalle = true});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.green[100],
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Buscar usuario';

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
          Usuario(
            operativa: "",
            sede: "",
            ingreso: "",
            area: "",
            puesto: "",
            nombres: "",
            apellidos: "",
            contacto: "",
            notas: "",
            snEquipo: "",
            estado: "",
            baja: "",
            correo: "",
            psw: "",
            tipolicencia: "",
            equipos: [],
          ),
        );
      },
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    filtro =
        user.where((User) {
          var d = User!.nombres + User.apellidos + User.area + User.snEquipo + User.snEquipo + User.correo!;
          return d.toUpperCase().contains(query.toUpperCase());
        }).toList();

    return ListView.builder(
      itemCount: filtro.length,
      itemBuilder:
          (_, i) => Container(
            decoration: BoxDecoration(
              color:
                filtro[i]!.estado == "BAJA"
                    ? myColor(filtro[i]!.estado)
                    : myColor(filtro[i]!.area),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "${filtro[i]!.sede} - ${filtro[i]!.area} / ${filtro[i]!.puesto}",
                style: const TextStyle(fontSize: 10),
              ),
              subtitle: Text(
                "${filtro[i]!.nombres} ${filtro[i]!.apellidos}",
                style: const TextStyle(fontSize: 13),
              ),
              onTap: () {
  if (mostrarDetalle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsuarioDetalleScreen(usuario: filtro[i]!),
      ),
    );
  } else {
    close(context, filtro[i]!);
  }
},
            ),
          ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filtro =
        user.where((User) {
          var d = User!.nombres + User.apellidos + User.area + User.snEquipo + User.snEquipo + User.correo!;
          return d.toUpperCase().contains(query.toUpperCase());
        }).toList();
    return ListView.separated(
      separatorBuilder:
          (context, i) => const Divider(color: Colors.white, height: 0),
      itemCount: filtro.length,
      itemBuilder:
          (_, i) => Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color:
                filtro[i]!.estado == "BAJA"
                    ? myColor(filtro[i]!.estado)
                    : myColor(filtro[i]!.area),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "${filtro[i]!.sede} - ${filtro[i]!.area} / ${filtro[i]!.puesto}",
                style: const TextStyle(fontSize: 10),
              ),
              subtitle: Text(
                "${filtro[i]!.nombres} ${filtro[i]!.apellidos}",
                style: const TextStyle(fontSize: 13),
              ),
              onTap: () {
  if (mostrarDetalle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsuarioDetalleScreen(usuario: filtro[i]!),
      ),
    );
  } else {
    close(context, filtro[i]!);
  }
},
            ),
          ),
    );
  }
}
