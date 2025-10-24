
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:application_sop/utils/cards.dart';
import 'package:flutter/material.dart';

class EquipoDetalle extends StatefulWidget {
  final Equipo equipo;
  const EquipoDetalle({super.key, required this.equipo});
  @override
  State<EquipoDetalle> createState() => EquiposDdetalleState();
}

class EquiposDdetalleState extends State<EquipoDetalle> {
  @override
  Widget build(BuildContext context) {
    Equipo e = widget.equipo;
    final estadoColor = myColor(e.estado!);
    return Scaffold(
      appBar: AppBar(
        title: Text(e.estado!),
        centerTitle: true,
        backgroundColor: estadoColor,        actions: [
        IconButton(onPressed: () {},
        icon: Icon(Icons.delete_forever, color: Colors.red),
        tooltip: "Baja equipo",)
        ]),
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          equipoCard(context, e, estadoColor)
        ],
      ),
    )
    );
  }
}