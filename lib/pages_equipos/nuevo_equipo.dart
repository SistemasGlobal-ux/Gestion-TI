
// ignore_for_file: library_private_types_in_public_api

import 'package:application_sop/maps/catalogos_combinados.dart';
import 'package:application_sop/maps/snake_case.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/push_data.dart';
import 'package:application_sop/utils/dropdow.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';

class AgregarEquipo extends StatefulWidget {
  const AgregarEquipo({super.key});

  @override
  _AgregarEquipoState createState() => _AgregarEquipoState();
}

class _AgregarEquipoState extends State<AgregarEquipo> {
  int? idOperativa, idSede, idTipo, idMarca, idModelo, idProcesador, idGen, idDiscop, idDiscos, idRam, idSo;
  String? textOperativa, textSede, textTipo, textMarca, textModelo, textProcesador, textGen, textDiscop, textDiscos, textRam, textSo;
  final TextEditingController serialController = TextEditingController();
  DateTime? fechaRegistro;
  // Aquí guardaremos los equipos
  List<Map<String, dynamic>> equipos = [];

  late Future<CatalogosCombinados> futureCatalogos;

  @override
  void initState() {
    super.initState();
    //futureCatalogos = fetchCatalogosEquipo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text('AGREGAR EQUIPO(S)'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<CatalogosCombinados>(
        future: futureCatalogos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          final catalogos = data.catalogos;
          final catalogosE = data.catalogosE;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                dropdownCatalogoG("Operativa", catalogos.operativas, idOperativa, (v, t) {textOperativa = t; idOperativa = v;}),
                dropdownCatalogoG("Sede", catalogos.sedes, idSede, (v, t){textSede = t; idSede = v;}),
                dropdownCatalogosE("Tipo", catalogosE.tipos, idTipo, (v, t){ textTipo = t; idTipo = v;}),
                dropdownCatalogosE("Marca", catalogosE.marcas, idMarca, (v, t){ textMarca = t; idMarca = v;}),
                dropdownCatalogosE("Modelo", catalogosE.modelos, idModelo, (v, t){ textModelo = t; idModelo = v;}),
                dropdownCatalogosE("Procesador", catalogosE.procesadores, idProcesador, (v, t){ textProcesador = t; idProcesador = v;}),
                dropdownCatalogosE("Generacion", catalogosE.generaciones, idGen, (v, t){ textGen = t; idGen = v;}),
                dropdownCatalogosE("Disco Principal", catalogosE.discos, idDiscop, (v, t){ textDiscop = t; idDiscop = v;}),
                dropdownCatalogosE("Disco Secundario", catalogosE.discos, idDiscos, (v, t){ textDiscos = t; idDiscos = v;}),
                dropdownCatalogosE("Ram", catalogosE.rams, idRam, (v, t){ textRam = t; idRam = v;}),
                dropdownCatalogosE("Sistema Operativo", catalogosE.sistemasOperativos, idSo, (v, t){ textSo = t; idSo = v;}),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                        controller: serialController,
                        decoration: InputDecoration(labelText: "Número de serie"),
                        ),
                      ),
                      IconButton(onPressed: agregarEquipo, icon: Icon(Icons.save_as_sharp), tooltip: "agregar equipo a lista"),
                    ],
                  ),
                  Container(margin: EdgeInsets.only(top: 10), color:Colors.blue[50], child: 
                  fechaField("Fecha de recepccion", fechaRegistro, (fecha) => setState(() => fechaRegistro = fecha), context)),
                  equipos.isNotEmpty ?
                  SizedBox(
                    height: 300, // o MediaQuery.of(context).size.height * 0.4
                    child: ListView.builder(
                      itemCount: equipos.length,
                      itemBuilder: (context, i) {
                        final eq = equipos[i];
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          color: Colors.greenAccent,
                          child: ListTile(
                            title: Text("${i+1}- Marca: ${eq['textMarca']} | Modelo: ${eq['textModelo']}", overflow: TextOverflow.ellipsis),
                            subtitle: Text("NS: ${eq['numero_serie']}", overflow: TextOverflow.ellipsis),
                            leading: IconButton(onPressed: (){duplicar(eq['numero_serie']);}, icon: Icon(Icons.control_point_duplicate), tooltip: "duplicar equipo",),
                            trailing: IconButton(onPressed: (){quitarEquipo(eq['numero_serie']);}, icon: Icon(Icons.delete), tooltip: "eliminar equipo"),
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  ): Container(),
                  equipos.isNotEmpty ?
                  ElevatedButton(
                    onPressed: (){guardarTodos(context);},
                    child: Text("Guardar todo"),
                  ) : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

dropdownCatalogoG(String label, item, int? selectedId, Function(int?, String?) onChanged) {
  return Row(
    children: [
      Expanded(
        child: DropdownCatalogo(
          label: label,
          items: item,
          selectedId: selectedId,
          onChanged: (value) {
            final seleccionado = item.firstWhere((e) => e.id == value.toString());
            final texto = seleccionado.nombre;
            setState(() => onChanged(value, texto));},
        ),
      ),
      IconButton(
        onPressed: () => _mostrarDialogoAgregar(label),
        icon: Icon(Icons.app_registration_outlined, color: Colors.blue),
        tooltip: "agregar $label",
      ),
    ],
  );
}

dropdownCatalogosE(String label, item, int? selectedId, Function(int?, String?) onChanged) {
  return Row(
    children: [
      Expanded(
        child: DropdownCatalogoE(
          label: label,
          items: item,
          selectedId: selectedId,
          onChanged: (value) {
            final seleccionado = item.firstWhere((e) => e.id == value.toString());
            final texto = seleccionado.nombre;
            setState(() => onChanged(value, texto));
            },
        ),
      ),
      IconButton(
        onPressed: () => _mostrarDialogoAgregar(label),
        icon: Icon(Icons.app_registration_outlined, color: Colors.blue),
        tooltip: "agregar $label"
      ),
    ],
  );
}


  void agregarEquipo() async {
    if (serialController.text.isEmpty) return;
    final fecha = myDate(fechaRegistro!);
    // Llamar servicio para guardar en la BD
    final idFecha = await addNewDato("recepciones", "recepcion", fecha);
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
    setState(() {
      serialController.clear();
    });
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
      final eBool = await addEquipo(e);
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
    void _mostrarDialogoAgregar(String tipo) {
  final TextEditingController nuevoController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text("Agregar $tipo"),
        content: TextField(
          controller: nuevoController,
          decoration: InputDecoration(hintText: tipo),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: Text("Guardar"),
            onPressed: () async {
              if (nuevoController.text.isNotEmpty) {
                // Llamar servicio para guardar en la BD
                final tabla = catalogosSC[tipo]?["plural"];
                final columna = catalogosSC[tipo]?["singular"];
                final dato = await addNewDato(tabla!, columna!, nuevoController.text);
                if (dato["status"] == "insertado") {
                setState(() {
                  //futureCatalogos = fetchCatalogosEquipo();
                  });
                // ignore: use_build_context_synchronously
                Navigator.pop(ctx);
                }else{
                  LoggerService.write(dato);
                }
                
              }
            },
          ),
        ],
      );
    },
  );
}
}