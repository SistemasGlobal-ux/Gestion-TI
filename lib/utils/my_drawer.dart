// ignore_for_file: non_constant_identifier_names

import 'package:application_sop/maps/tecnicos.dart';
import 'package:application_sop/services/fetch_data.dart';
import 'package:flutter/material.dart';

MyDrawer(context) {
  return Drawer(
    backgroundColor: const Color.fromARGB(237, 96, 125, 139),
    child: FutureBuilder<List<Tecnico>>(
      future: obtenerTecnicos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar técnicos'));
        } else {
          final tecnicos = snapshot.data!;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(87, 33, 149, 243),
                ),
                child: Text('Menú'),
              ),
              ExpansionTile(
                leading: Icon(Icons.settings),
                title: Text('Configurar Técnico'),
                children:
                    tecnicos.map((tecnico) {
                      bool esSeleccionado = tecnico.nombres == "JUAN";
                      return ListTile(
                        title: Text("${tecnico.nombres} ${tecnico.apellidos}"),
                        trailing: Icon(
                          Icons.check_circle,
                          color: esSeleccionado ? Colors.green : Colors.grey,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
              ),
            ],
          );
        }
      },
    ),
  );
}
