import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class Add_equipos extends StatefulWidget {
  const Add_equipos({super.key});

  @override
  State<Add_equipos> createState() => _Add_equiposState();
}

class _Add_equiposState extends State<Add_equipos> {

  int? idOperativa, idSede, idTipo, idMarca, idModelo, idProcesador, idGen, idDiscop, idDiscos, idRam, idSo;
  String? textOperativa, textSede, textTipo, textMarca, textModelo, textProcesador, textGen, textDiscop, textDiscos, textRam, textSo;
  final TextEditingController serialController = TextEditingController();
  DateTime? fechaRegistro;
  // Aquí guardaremos los equipos
  List<Map<String, dynamic>> equipos = [];

  @override
  Widget build(BuildContext context) {

    final CatalogosE catalogosE = Provider.of<CatalogosEquiposListProvider>(context).catalogosE;
    final Catalogos catalogos = Provider.of<CatalogosListProvider>(context).catalogos;

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de equipos"), 
        centerTitle: true, 
        backgroundColor: const Color.fromARGB(255, 92, 141, 163), 
        toolbarHeight: 40),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //izquierda
                Expanded(
                    flex: 2,
                    child: Container(
                    color: const Color.fromARGB(255, 92, 141, 163),
                    margin: EdgeInsets.only(top:10.0, bottom: 8.0,left: 16.0, right: 8.0),
                    padding: EdgeInsets.all(11.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customcard(Text("Especificaciones técnicas")),
                          Divider(height: 25),
                          listEquipo("Marca", catalogosE.marcas, idMarca),
                          listEquipo("Modelo", catalogosE.modelos, idModelo),
                          listEquipo("Procesador", catalogosE.procesadores, idProcesador),
                          listEquipo("Memoria RAM", catalogosE.rams, idRam),
                          listEquipo("Disco principal", catalogosE.discos, idDiscop),
                          listEquipo("Disco secundario", catalogosE.discos, idDiscos),
                          listEquipo("Sistema operqativo", catalogosE.sistemasOperativos, idSo),
                          TextField( controller: serialController,
                          decoration: InputDecoration(labelText: "Número de serie"),
                        ),
                        ]
                      ),
                    ))),
                //derecha
                Expanded(
                      flex: 1,
                      child: Container(
                    color: const Color.fromARGB(255, 92, 141, 163),
                    margin: EdgeInsets.only(top: 10.0, bottom: 8.0,left: 8.0, right: 16.0),
                    padding: EdgeInsets.all(11.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customcard(Text("Información general")),
                          Divider(height: 25),
                          listGeneral("Operativa", catalogos.operativas, idOperativa),
                          listGeneral("Sede", catalogos.sedes, idSede),
                          listEquipo("Tipo", catalogosE.tipos, idTipo),
                          Container(margin: EdgeInsets.only(top: 10), color:Colors.blue[50], child: 
                          fechaField("Fecha de recepccion", fechaRegistro, (fecha) => setState(() => fechaRegistro = fecha), context)),
                          customcarg(iconButtonCustom("Guardar y salir", Icons.save_as_sharp, (){})),
                          customcarg(iconButtonCustom("Duplicar ultimo", Icons.save_as_sharp, (){})),
                          customcarg(iconButtonCustom("Registrar otro", Icons.save_as_sharp, (){}))
                        ]
                      ),
                    ))
                  ),
              ],
      )
    );
  }

   customcard(Widget widget){
     return SizedBox(
      width: double.infinity,
      child: widget);
    }

    customcarg(Widget widget){
      return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: widget));
    }

    listGeneral(String label, List<CatalogoItem> item, int? selectedId){
      return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: DropdownCatalogo(
          label: label,
          items: item,
          selectedId: selectedId,
          onChanged: (value) => setState(() => selectedId = value),
          ),
      ); 
    }

   listEquipo(String label, List<CatalogosEquipo> item, int? selectedId){
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: DropdownCatalogoE(label: label,
        items: item,
        selectedId: selectedId,
        onChanged: (value) => setState(() => selectedId = value),
      ),
    );
   }

   void agregarEquipo() async {
    if (serialController.text.isEmpty) return;
    final fecha = myDate(fechaRegistro!);
    // Llamar servicio para guardar en la BD
    // TODO: modificar: final idFecha = await addNewDato("recepciones", "recepcion", fecha);
    final idFecha = {};
    if(idFecha["status"] != "error"){
    final newEquipo = {
      "textOperativa": textOperativa,
      "textSede": textSede,
      "textTipo": textTipo,
      "textMarca": textMarca,
      "textModelo": textModelo,
      "textProcesador": textProcesador,
      "textGen": textGen,
      "textDiscop": textDiscop,
      "textDiscos": textDiscos,
      "textRam": textRam,
      "textSo": textSo,
      "id_recepcion": idFecha["id"],
      "id_operativa": idOperativa,
      "id_sede": idSede,
      "id_tipo": idTipo,
      "numero_serie": serialController.text,
      "id_marca": idMarca,
      "id_modelo": idModelo,
      "id_procesador": idProcesador,
      "id_generacion": idGen,
      "id_disco_principal": idDiscop,
      "id_disco_secundario": idDiscos,
      "id_ram": idRam,
      "id_sistema_operativo": idSo,
      "id_estado": 2, //(siempre sera 2 de "STOCK")
      "id_user": "STOCK", 
      "nas": "~", 
      "fecha_entrega": "~", 
      "hoja_entrega": "~", 
      "notas": "~", 
     "baja": "~", 
     "detalle_baja": "~",
    };
    equipos.add(newEquipo);
    setState(() {serialController.clear();});
  }else{
    LoggerService.write("${idFecha["status"]} - ${idFecha["mensaje"]} ");
  }
  }

  duplicar(String ns){
    return showDialog(
      context: context,
      builder: (ctx) {
      final newSerialController = TextEditingController();
      return AlertDialog(
      title: Text("Duplicar datos de equipo"),
      content: TextField(
      controller: newSerialController,
      decoration: InputDecoration(labelText: "Nuevo NS")),
      actions: [
        TextButton(
          onPressed: () {
            duplicarEquipo(newSerialController.text, ns);
            Navigator.pop(ctx);
          },
          child: Text("Duplicar"),
        )
      ],
    );
  },
   );
  }

  void duplicarEquipo(String nuevoSerial, String ns) {
    if (equipos.isEmpty) return;
    final seleccionado = equipos.firstWhere((e) => e["numero_serie"] == ns);
    final equipo = seleccionado;
    final duplicado = Map<String, dynamic>.from(equipo);
    duplicado["numero_serie"] = nuevoSerial;
    setState(() {
      equipos.add(duplicado);
    });
  }

  void quitarEquipo(String ns){
    if(equipos.isEmpty) return;
    setState(() {
      equipos.removeWhere((e) => e["numero_serie"] == ns);
    });
  }

  void guardarTodos(context) async {
    // Aquí deberías mandar la lista "equipos" a tu API
    for (var e in equipos) {
      final eBool = false;
      // TODO: modificar: final eBool = await addEquipo(e);
      if (eBool == true) {
      dialogo(context, "Equipo ${e["numero_serie"]} registrado con exito");
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pop();
      }else{
      dialogoFalla(context, "No se pudo registrar equipo ${e["numero_serie"]}");
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
      }
    }
    setState(() {equipos.clear();});
  }

}

