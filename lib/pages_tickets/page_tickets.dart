

import 'package:application_sop/busqueda_delegates/custom_search_user.dart';
import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/soportes.dart';
import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/maps/tecnicos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/services/fetch_data.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/utils/calendar_datos.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:application_sop/utils/custom_imput.dart';
import 'package:application_sop/utils/custom_listas.dart';
import 'package:application_sop/utils/format_text.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AltaTicketPage extends StatefulWidget {
  const AltaTicketPage({super.key});

  @override
  State<AltaTicketPage> createState() => _AltaTicketPageState();
}

class _AltaTicketPageState extends State<AltaTicketPage> {
  final _formKey = GlobalKey<FormState>();

  late Future<Map<String, List<Usuario>>?>? usuariosPorArea;
  late Future<List<Tecnico>> tecnicos;  

  // Controladores
  late TextEditingController usuarioController;
  late TextEditingController sedeController;
  late TextEditingController areaController;

  final TextEditingController problemaCtrl = TextEditingController();
  final TextEditingController solucionCtrl = TextEditingController();
  final TextEditingController notasCtrl = TextEditingController();

  int? tipoFallaSeleccionada;
  int? tipoSoporteSeleccionado;
  int? estadoSeleccionado;
  int? prioridadSeleccionada;

  Usuario? usuarioSeleccionado;
  DateTime? fechaInicio, fechaCierre;
  String? idUsuario;

    @override
  void initState() {
    super.initState();
    usuariosPorArea = fetchUsuariosArea();
    tecnicos = obtenerTecnicos();
    usuarioController = TextEditingController();
    sedeController = TextEditingController();
    areaController = TextEditingController();
    setState(() {});
  }

    @override
  void dispose() {
    // Aquí se limpia el controller cuando se destruye la pantalla
    usuarioController.dispose();
    sedeController.dispose();
    areaController.dispose();
    super.dispose();
  }

  DateTimeRange dateRange = DateTimeRange(
   start: DateTime(kToday.year, kToday.month , kToday.day),
   end: DateTime(kToday.year, kToday.month , kToday.day),
  );

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(kToday.year, kToday.month - 3, kToday.day),
      lastDate: DateTime(kToday.year, kToday.month + 3, kToday.day),
    );
    setState(() {
      dateRange = newDateRange ?? dateRange;
      createBitacora(dateRange);
    });
  }

 Future createBitacora(dateRange) {return showDialog(context: context, builder: (_) => fechasBitacora(context, dateRange));}
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
      title: const Text("Nuevo Ticket"), 
      centerTitle: true, 
      backgroundColor: Colors.greenAccent,
      toolbarHeight: 35,
      actions: [IconButton(onPressed: () => pickDateRange(), icon: Icon(Icons.picture_as_pdf_rounded))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              //myButton(()async{_seleccionarTecnicoDesdeLista(await tecnicos);},0, 15, Icons.supervisor_account_sharp, "TECNICO: ${tecnico.nombres} ${tecnico.apellidos}"),
              const SizedBox(height: 10),
                myResponsiveButton(
                  () async {
                    final data = await usuariosPorArea;
                    final lista = data?.values.expand((u) => u).toList() ?? [];
                    usuarioSeleccionado =  await showSearch(
                      // ignore: use_build_context_synchronously
                      context: context,delegate: BusquedaUserDelegate(lista, mostrarDetalle: false));
                 if (usuarioSeleccionado != null) {
                  setState(() {
                    usuarioController.text = '${usuarioSeleccionado!.nombres} ${usuarioSeleccionado!.apellidos}';});}
                    sedeController.text = usuarioSeleccionado!.sede;
                    areaController.text = usuarioSeleccionado!.area;
                    idUsuario = usuarioSeleccionado!.id;
                  },
                  Icons.person,
                  "Busqueda",
                  true,
                ),
               _showInfo("SEDE",sedeController, areaController.text),
               _showInfo("AREA",areaController, areaController.text),
               _showInfo("USUARIO", usuarioController, areaController.text),
                //meter IA para redaccion/correcion
              const SizedBox(height: 10),

              buildRadioGroup(idTipoSoporteMap, tipoSoporteSeleccionado, (val) { setState(() {tipoSoporteSeleccionado = val;});}, "Tipo de Soporte"),
              buildRadioGroup(idTipoFallaMap, tipoFallaSeleccionada, (val) {setState(() {tipoFallaSeleccionada = val;});}, "Tipo de Falla"),
              buildRadioGroup(idEstadoMap, estadoSeleccionado, (val) {setState(() {estadoSeleccionado = val;});}, "Estado"),
              buildRadioGroup(idPrioridadMap, prioridadSeleccionada, (val) {setState(() {prioridadSeleccionada = val;});}, "Prioridad"),

              const SizedBox(height: 10),
              CustomImput(placeholder: "PROBLEMA", textControler: problemaCtrl, validator: (val) =>
            val == null || val.isEmpty ? "Campo requerido" : null),
              CustomImput(placeholder: "SOLUCIÓN", textControler: solucionCtrl, validator: (val) =>
            val == null || val.isEmpty ? "Campo requerido" : null),
              CustomImput(placeholder: "NOTAS", textControler: notasCtrl),
              fechaField("Fecha de inicio", fechaInicio, (fecha) => setState(() => fechaInicio = fecha), context),
              fechaField("Fecha de cierre", fechaCierre, (fecha) => setState(() => fechaCierre = fecha), context),
              const SizedBox(height: 20),
              myButton(_guardarTicket, 0, 0, Icons.add, "Guardar Ticket")
            ],
          ),
        ),
      ),
    );
  }




  Widget _showInfo(String label, TextEditingController controller, area){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 7, bottom: 5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: myColor(area),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label : ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              TextSpan(
                text: controller.text,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
    );
  }



  Widget buildRadioGroup(opciones, int? selectedValue, Function(int?) onChanged, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ...opciones.entries.map((entry) => RadioListTile<int>(
            value: entry.key,
            groupValue: selectedValue,
            title: Text(entry.value!),
            onChanged: onChanged,
          ))
    ],
  );
  }

  void _guardarTicket() async {
    TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;
    if (_formKey.currentState!.validate()) {
      final sede = idSedeMap[usuarioSeleccionado!.sede];
      final nuevoTicket = Soportes(
        id: null,
        idUsuario: idUsuario.toString(), 
        idTecnico: tecnico.token!,
        idSede: sede.toString(),
        idTipoSop: tipoSoporteSeleccionado.toString(),
        idTipoFalla: tipoFallaSeleccionada.toString(), 
        idEstado: estadoSeleccionado.toString(),
        idPrioridad: prioridadSeleccionada.toString(), 
        problema: formatearTexto(problemaCtrl.text), 
        solucion: formatearTexto(solucionCtrl.text), 
        fechaInicio: fechaInicio == null ? myDate(DateTime.now()) : myDate(fechaInicio!), 
        fechaCierre: fechaCierre == null ? myDate(DateTime.now()) : myDate(fechaCierre!), 
        notas: notasCtrl.text.isEmpty ? "~" : notasCtrl.text);
      final res = await registrarNewSop(context, "Registrando ticket", nuevoTicket);
      await resetDatos(res["status"]);
    }
  }

    resetDatos(res) {
    if (res == true) {
    problemaCtrl.clear();
    solucionCtrl.clear();
    notasCtrl.clear();
    } else {
    LoggerService.write("No se pudo limpiar datos $res");
    }
  }

}
