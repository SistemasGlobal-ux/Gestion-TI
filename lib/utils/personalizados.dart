// ignore_for_file: use_build_context_synchronously

import 'package:application_sop/busqueda_delegates/custom_search_equipo.dart';
import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/desktop/pages/edit_equipo.dart';
import 'package:application_sop/desktop/pages/edit_user.dart';
import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/modelos%20pdfs/mant_correctivo.dart';
import 'package:application_sop/modelos%20pdfs/mant_preventivo.dart';
import 'package:application_sop/modelos%20pdfs/recepcion_equipo.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:application_sop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

myButton(
  Function()? ontap,
  double? width,
  double left,
  IconData? icon,
  String text,
) {
  return InkWell(
    onTap: ontap,
    child: Container(
      width: width,
      padding: EdgeInsets.only(left: left),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon), Text(text)]),
    ),
  );
}

Widget myResponsiveButton(
  VoidCallback onPressed,
  IconData icon,
  String label,
  bool compactMode,
) {
  return TextButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 20),
    label: compactMode ? SizedBox.shrink() : Text(label),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

myCustomB(Widget? child, double h) {
  return Expanded(
    child: Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: h),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    ),
  );
}

Widget myElevatedB(String label, Function() onPressed) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isCompact = constraints.maxWidth < 120; 
      // ajusta el breakpoint según tu diseño
      return ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 20,
              vertical: 17.5,
            ),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: isCompact
            ? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
            : Text(label),
      );
    },
  );
}


Widget iconButtonCustom(String label, IconData? icon, Function() onPressed) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isCompact = constraints.maxWidth < 150; 
      //Ajusta el valor según el punto de quiebre que desees
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: isCompact
            ? const SizedBox.shrink() //Oculta el texto en modo compacto
            : Text(label),
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 16,
              vertical: 17.5,
            ),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
              side: const BorderSide( color: Colors.white38),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(1.5),
        ),
      );
    },
  );
}

Widget iconButtonSingle(String tootip, IconData icon,Color? color, Function()? onpresed){
  return IconButton(
  tooltip: tootip,
  icon: Icon(icon, color: color),
  onPressed: onpresed,
  );
}


Widget customResumenCard(
  String title,
  String value,
  IconData? icon,
  Function()? onTap,
) {
  return Expanded(
    child: LayoutBuilder(
      builder: (context, constraints) {
        bool isCompact = constraints.maxWidth < 180; 
        //Cambia 180 según el punto donde quieras ocultar texto
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: isCompact
                  ? Center(
                      //Vista compacta (solo íconos)
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 28, color: Colors.black87),
                          const SizedBox(height: 4),
                          Text(value,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(icon, color: Colors.black87),
                            Text(title,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    ),
  );
}

myTextfield(String label, TextEditingController dataController) {
  return Expanded(
    child: TextField(
      controller: dataController,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

Future<List<Equipo>> ordenarEquiposPorEstado(List<Equipo> listaOriginal) async {
  listaOriginal.sort((a, b) {
    final estadoA = a.estado?.toUpperCase() ?? '';
    final estadoB = b.estado?.toUpperCase() ?? '';
    final prioridadA = prioridadEstado[estadoA] ?? 99;
    final prioridadB = prioridadEstado[estadoB] ?? 99;
    return prioridadA.compareTo(prioridadB);
  });
  return listaOriginal;
}

myDate(DateTime date){
  return DateFormat('dd/MM/yyyy').format(date);
}


fechasBitacora(context, DateTimeRange dateRange){
    return AlertDialog(
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    alignment: Alignment.center,
    title: const Text(
      "Fechas seleccionadas:", style: TextStyle(color: Colors.lightBlue),
      textAlign: TextAlign.center,
    ),
    content: SingleChildScrollView(
      child: Column(
      children: [
        Text("del ${myDate(dateRange.start)} al ${myDate(dateRange.end)}")
      ],
    )),
    actions: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              child: const Icon(Icons.save),
              onPressed: () async {
                Navigator.of(context).pop(true);
                generarBitacora(context, dateRange);
              }
          ),
        ],
      ),
    ],
  );
}

rangoDeFechas(DateTimeRange dateRange){
  final diferences = dateRange.end.difference(dateRange.start).inDays;
   List myDateRange = [];
   myDateRange.add(myDate(dateRange.start));
    
  for (var i = 1; i < diferences + 1; i++) {
    var newDate = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day + i);
    myDateRange.add(myDate(newDate));
  }
  return myDateRange;
}

  Widget fechaField(String label, DateTime? fecha, Function(DateTime) onPick, context) {
    return ListTile(
      title: Text(fecha == null ? label : "${myDate(fecha)}"),
      trailing: const Icon(Icons.date_range),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: fecha ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          locale: const Locale("es", "ES")
        );
        if (picked != null) onPick(picked);
      },
    );
  }

  void dialogo(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha(
      (0.8 * 255).toInt(),
    ), // Fondo semi-transparente detrás del diálogo
    builder:
        (_) => Dialog(
          backgroundColor: Colors.green.withAlpha(
            (0.8 * 255).toInt(),
          ), // Fondo verde translúcido
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 4, // Tamaño del grosor
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
  );
}

  void dialogoFalla(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha(
      (0.8 * 255).toInt(),
    ), // Fondo semi-transparente detrás del diálogo
    builder:
        (_) => Dialog(
          backgroundColor: Colors.red.withAlpha(
            (0.8 * 255).toInt(),
          ), // Fondo verde translúcido
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 4, // Tamaño del grosor
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
  );
}

  void dialogoError(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha(
      (0.8 * 255).toInt(),
    ), // Fondo semi-transparente detrás del diálogo
    builder:
        (_) => Dialog(
          backgroundColor: const Color.fromARGB(255, 228, 112, 104).withAlpha(
            (0.8 * 255).toInt(),
          ), // Fondo verde translúcido
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Icon(Icons.cancel_outlined, size: 80 ,color: Colors.white)
                ),
                const SizedBox(height: 20),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
  );
}

 void showListEquipos(BuildContext context,List<Equipo> equipos, Function(int) onEquipoSeleccionado) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black87,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona un equipo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250, // limita el alto del diálogo
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: equipos.length,
                  itemBuilder: (context, index) {
                    final equipo = equipos[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.computer, color: Colors.blue),
                        title: Text(
                          "${equipo.marca} ${equipo.modelo}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          'Serie: ${equipo.numeroSerie}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        onTap: () {
                          Navigator.pop(context); // cerrar diálogo
                          onEquipoSeleccionado(index); // devolver equipo
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


 void showEquipos(BuildContext context, Usuario user) {
  String text = user.equipos!.length > 1 ? 'EQUIPOS ASIGNADOS A ${user.nombres}' : 'EQUIPO ASIGNADO A ${user.nombres}';

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black45,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.4,
            maxHeight: MediaQuery.of(context).size.width * 0.4
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text( text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  //height: 250, // limita el alto del diálogo
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.equipos!.length,
                    itemBuilder: (context, index) {
                      final equipo = user.equipos![index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.computer, color: Colors.blue),
                          title: Text(
                            "${equipo.marca} ${equipo.modelo}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'Serie: ${equipo.numeroSerie}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Salir'),
                  )]),
              ],
            ),
          ),
        ),
      );
    },
  );
}


 void showInfoUser(BuildContext context, Usuario user) {

  String text = user.equipos!.length > 1 || user.equipos!.isEmpty ? '${user.equipos!.length} EQUIPOS ASIGNADOS' : '${user.equipos!.length} EQUIPO ASIGNADO';
  final List<Equipo> equiposStock = Provider.of<EquiposListProvider>(context, listen: false).estock;
  Equipo? equipo;
  DateTime hoy = DateTime.now();

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black45,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.person),
                    Text(user.sede,style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                    iconButtonSingle("Editar usuario", Icons.settings, Colors.lightGreen, (){editUsuario(context, user);})
                  ],
                ),
                CopiText(label: "Area", value: user.area),
                CopiText(label: "Usuario", value: "${user.nombres} ${user.apellidos}", showIconAndAnimation: true),
                CopiText(label: "Correo", value: user.correo!, showIconAndAnimation: true),
                CopiText(label: "Contraseña", value: user.psw!, showIconAndAnimation: true),
                CopiText(label: "Fecha de ingreso", value: user.ingreso),
                const SizedBox(height: 15),
                Text(text),
                SizedBox(
                  height: 250, // limita el alto del diálogo
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.equipos!.length,
                    itemBuilder: (context, index) {
                      final equipo = user.equipos![index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.computer, color: Colors.blue),
                          title: 
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(equipo.tipo!,style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                          Row(
                            children: [
                          iconButtonSingle("Eliminar equipo de usuario", Icons.delete,Colors.redAccent, () async {
                            await Provider.of<EquiposListProvider>(context, listen: false).deleteEquipoUser(equipo.numeroSerie);
                            pdfRecepccionEquipo(user, equipo, context);
                             Navigator.pop(context);
                          } ),
                          SizedBox(width: 10),
                          iconButtonSingle("Editar equipo", Icons.edit, Colors.blueGrey, () => editEquipo(context, equipo))
                            ],
                          ),
                          ]),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CopiText(label: "Equipo", value: "${equipo.marca} ${equipo.modelo}", showIconAndAnimation: true),
                            CopiText(label: "NS", value: "${equipo.numeroSerie}", showIconAndAnimation: true),
                            CopiText(label: "NAS", value: equipo.nas!),
                            CopiText(label: "D. principal", value: equipo.discoPrincipal!),
                            CopiText(label: "D. secundario", value: equipo.discoSecundario!),
                            CopiText(label: "Memoria RAM", value: equipo.ram!),
                            CopiText(label: "Procesador", value: "${equipo.procesador} ${equipo.generacion}"),
                            ],
                          )
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                    onPressed: () async {
                      equipo = await showSearch(
                      context: context,delegate: BusquedaEquipoDelegate(equiposStock));
                      if(equipo!.numeroSerie!.isNotEmpty){
                       final nass = user.equipos!.isNotEmpty ? user.equipos![0].nas :  "pendiente";
                       final res = await addEquipo(context, text, user, nass, myDate(hoy), equipo!.numeroSerie!);
                       if (res == true) {
                       Navigator.pop(context);
                       }
                      }else{
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Asignar equipo'),
                  ),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Salir'),
                  ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

 void showInfoUserAndroid(BuildContext context, Usuario user, TechSuppor tecnico) {

  String text = user.equipos!.length > 1 || user.equipos!.isEmpty ? '${user.equipos!.length} EQUIPOS ASIGNADOS' : '${user.equipos!.length} EQUIPO ASIGNADO';
  final List<Equipo> equiposStock = Provider.of<EquiposListProvider>(context, listen: false).estock;
  Equipo? equipo;
  DateTime hoy = DateTime.now();

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black45,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(user.sede,style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                    iconButtonSingle("Editar usuario", Icons.settings, Colors.lightGreen, (){editUsuario(context, user);})
                  ],
                ),
                CopiText(label: "Area", value: user.area),
                CopiText(label: "Usuario", value: "${user.nombres} ${user.apellidos}", showIconAndAnimation: true),
                CopiText(label: "Correo", value: user.correo!, showIconAndAnimation: true),
                CopiText(label: "Contraseña", value: user.psw!, showIconAndAnimation: true),
                CopiText(label: "Fecha de ingreso", value: user.ingreso),
                const SizedBox(height: 10),
                Text(text),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.equipos!.length,
                    itemBuilder: (context, index) {
                      final equipo = user.equipos![index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(equipo.tipo!,style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                          iconButtonSingle("Eliminar equipo de usuario", Icons.delete,Colors.redAccent, () async {
                            await Provider.of<EquiposListProvider>(context, listen: false).deleteEquipoUser(equipo.numeroSerie);
                            pdfRecepccionEquipo(user, equipo, context);
                             Navigator.pop(context);})
                          ]),
                          subtitle: Column(
                            children: [
                            CopiText(label: "Equipo", value: "${equipo.marca} ${equipo.modelo}", showIconAndAnimation: true),
                            CopiText(label: "NS", value: "${equipo.numeroSerie}", showIconAndAnimation: true),
                            CopiText(label: "NAS", value: equipo.nas!),
                            CopiText(label: "D. principal", value: equipo.discoPrincipal!),
                            CopiText(label: "D. secundario", value: equipo.discoSecundario!),
                            CopiText(label: "Memoria RAM", value: equipo.ram!),
                            CopiText(label: "Procesador", value: "${equipo.procesador} ${equipo.generacion}"),
                            rowIcons(tecnico.rol, user, context, index)
                            ],
                          )
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                    onPressed: () async {
                      equipo = await showSearch(
                      context: context,delegate: BusquedaEquipoDelegate(equiposStock));
                      if(equipo!.numeroSerie!.isNotEmpty){
                       final nass = user.equipos!.isNotEmpty ? user.equipos![0].nas : "pendiente";
                       final res = await addEquipo(context, text, user, nass, myDate(hoy), equipo!.numeroSerie!);
                       if (res == true) {
                       Navigator.pop(context);
                       }
                      }else{
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Asignar equipo'),
                  ),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Salir'),
                  ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

rowIcons(rol, user, context, i){
  return 
  rol == "admin" || rol == "tecnico"?
  Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      iconButtonSingle("PDF Equipo", Icons.picture_as_pdf, Colors.lightBlue, (){
        if(user.equipos!.length > 1){generarPdfIngreso(context, user, "Generando PDF...", i);}else{}
      }),
      iconButtonSingle("PDF Preventivo", Icons.build_circle, Colors.green.shade700, (){
        if(user.equipos!.length > 1){pdfMantPrevEquipo(user, user.equipos[i], context);}else{}
      }),
      iconButtonSingle("PDF Correctivo", Icons.home_repair_service_outlined, Colors.orange.shade700, (){
        if(user.equipos!.length > 1){pdfMantCorretEquipo(user, user.equipos[i], context);}else{}
      }),
    ],
   ) 
   : Container();
}


 void showInfoEquipo(BuildContext context, Equipo equipo) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black45,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.computer, color: myColor(equipo.estado!)),
                    Text(equipo.tipo!,style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete), color: Colors. redAccent),
                  ],
                ),
                SizedBox(
                  height: 250, // limita el alto del diálogo
                  child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: 
                        ListTile(
                          title: CopiText(label: "Equipo", value: "${equipo.marca} ${equipo.modelo}", showIconAndAnimation: true),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CopiText(label: "NS", value: "${equipo.numeroSerie}", showIconAndAnimation: true),
                            CopiText(label: "Procesador", value: "${equipo.procesador} ${equipo.generacion}"),
                            CopiText(label: "Disco princial", value: equipo.discoPrincipal!),
                            CopiText(label: "Disco secundario", value: equipo.discoSecundario!),
                            CopiText(label: "Memoria RAM", value: equipo.ram!),
                            CopiText(label: "Usuario NAS", value: equipo.nas!),
                            CopiText(label: "Estado", value: equipo.estado!),
                            equipo.estado! == "ENTREGADO" ?
                            CopiText(label: "Fecha de entrega", value: equipo.fechaEntrega!) : Container(),
                            CopiText(label: "Sede", value: equipo.sede!),
                          
                            ],
                          )
                        ),
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                equipo.estado == "STOCK" 
                ? TextButton(onPressed: () async {}, child: const Text('Asignar'))
                :TextButton(onPressed: () async {}, child: const Text('Reasignar')),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Salir'),
                  ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}