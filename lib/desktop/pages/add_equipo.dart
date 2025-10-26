import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/providers/providers.dart';
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
    //final Catalogos futureCatalogos = Provider.of<CatalogosCombinados>(context).catalogos;
    final Catalogos catalogos = Provider.of<CatalogosListProvider>(context).catalogos;

    return Scaffold(
      appBar: AppBar(title: Text("Registro de equipos"), centerTitle: true, backgroundColor: const Color.fromARGB(255, 92, 141, 163), toolbarHeight: 40),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                    color: const Color.fromARGB(255, 92, 141, 163),
                    margin: EdgeInsets.only(top:10.0, bottom: 8.0,left: 16.0, right: 8.0),
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        customcard(Text("Especificaciones técnicas"))
                      ]
                    ))
                      ),
                Expanded(
                      flex: 1,
                      child: Container(
                    color: const Color.fromARGB(255, 92, 141, 163),
                    margin: EdgeInsets.only(top: 10.0, bottom: 8.0,left: 8.0, right: 16.0),
                    padding: EdgeInsets.all(11.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        customcard(Text("Información general")),
                            DropdownCatalogo(label: 'Operativa',
                            items: catalogos.operativas,
                            selectedId: idOperativa,
                            onChanged: (value) => setState(() => idOperativa = value),
                            ),
                            DropdownCatalogo(
                            label: 'Sede',
                            items: catalogos.sedes,
                            selectedId: idSede,
                            onChanged: (value) => setState(() => idSede = value),
                            ),
                            Container(margin: EdgeInsets.only(top: 10), color:Colors.blue[50], child: 
                    fechaField("Fecha de recepccion", fechaRegistro, (fecha) => setState(() => fechaRegistro = fecha), context)),
                    DropdownCatalogo(label: 'Operativa',
                            items: catalogos.operativas,
                            selectedId: idOperativa,
                            onChanged: (value) => setState(() => idOperativa = value),
                            ),
                            DropdownCatalogo(
                            label: 'Sede',
                            items: catalogos.sedes,
                            selectedId: idSede,
                            onChanged: (value) => setState(() => idSede = value),
                            ),
                      ]
                    ))
                      ),
              ],
            ),
            customcarg(iconButtonCustom("Guardar y salir", Icons.save_as_sharp, (){})),
            customcarg(iconButtonCustom("Agregar a lista", Icons.save_as_sharp, (){})),
            customcarg(iconButtonCustom("Guardar y registrar otro", Icons.save_as_sharp, (){}))
          ],
        ),
      )
       
    );
  }
   customcard(Widget widget){
    return SizedBox(
      width: double.infinity,
      child: widget,
    );}
    customcarg(Widget widget){
      return SizedBox(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 2, top: 2),
        padding: EdgeInsets.all(8),
        child: widget));
    }
   
}

