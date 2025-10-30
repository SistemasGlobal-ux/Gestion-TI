
// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'package:application_sop/busqueda_delegates/custom_search_equipo.dart';
import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:application_sop/utils/utils.dart';
import 'package:application_sop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Add_usuario extends StatefulWidget {
  const Add_usuario({super.key});

  @override
  State<Add_usuario> createState() => _Add_usuarioState();
}

class _Add_usuarioState extends State<Add_usuario> {

  String fecha = myDate(DateTime.now());
  int? idArea, idSede, idPuesto, idOperativa;
  String dominioSeleccionado = '@administracionglobal.mx';
  Equipo? equipo;

  final TextEditingController namelCtrl = TextEditingController();
  final FocusNode nameNode = FocusNode(); 
  final TextEditingController lastNamelCtrl = TextEditingController();
  final FocusNode lastnameNode = FocusNode();
  final TextEditingController phoneCtrl = TextEditingController();
  final FocusNode phoneNode = FocusNode();
  final TextEditingController correoController = TextEditingController();
  final FocusNode correoNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController equipoCtrl = TextEditingController();
  final TextEditingController nasCtrl = TextEditingController();
  DateTime? fechaRegistro;

  final List<String> dominios = [
    '@administracionglobal.mx',
    '@marez.com.mx',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Usuario> usuariosActivos = Provider.of<UsuariosListProvider>(context).users;
    final List<Equipo> equiposStock = Provider.of<EquiposListProvider>(context).estock;
    final Catalogos catalogos = Provider.of<CatalogosListProvider>(context).catalogos;

    return Scaffold(
      appBar: AppBar(title: Text("Agregar usuario"), centerTitle: true, backgroundColor: const Color.fromARGB(255, 92, 141, 163), toolbarHeight: 40),
      body: Row(
        children:[
              //izquierda
              Expanded(
                flex: 2,
                child: Container(
                  color: const Color.fromARGB(255, 92, 141, 163),
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(5.0),    
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Datos del colaborador"),
                        ],
                      ),
                      CustomImput(placeholder: "Nombre(s)",textControler: namelCtrl ,node: nameNode, nexNode: lastnameNode,),
                      CustomImput(placeholder: "Apellidos", textControler: lastNamelCtrl, node: lastnameNode, nexNode: phoneNode,),
                      CustomImput(placeholder: "Contacto",textControler: phoneCtrl, node: phoneNode, nexNode: correoNode,),
                      Row(
                        children: [
                          Text("Asignacion de correo"),
                        ],
                      ),
                      CustomImput(placeholder: "Correo", textControler: correoController, node: correoNode,),
                      DropdownButtonHideUnderline(
                                child: Padding(
                                   padding: const EdgeInsets.only(left: 15, right: 15),
                                   child: DropdownButton<String>(
                                    padding: EdgeInsets.only(left: 8, right: 5),
                                    elevation: 2,
                                    isDense: true,
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(10),
                                    value: dominioSeleccionado,
                                    items:dominios.map((d) => DropdownMenuItem( 
                                    value: d,
                                    child: Text(maxLines: 1,overflow: TextOverflow.ellipsis,"dominio: $d"))).toList(),
                                    onChanged: (valor) {
                                      if (valor != null) {
                                        String texto = correoController.text.trim();
                                        if(texto.contains("@")){
                                          texto = texto.split('@').first;
                                        }
                                      setState(() {
                                        dominioSeleccionado = valor;
                                       correoController.text = "$texto$valor";
                                        });}}),
                          )),
                          CustomImput(placeholder: 'contraseña' ,textControler:  passwordController),
                          Row(children: [
                            Text("Asignacion de equipo"),
                          ]),
                          CustomImput(placeholder:  "Equipo", textControler:  equipoCtrl),
                          CustomImput(placeholder:  "Usuario NAS", textControler:  nasCtrl),
                          ],
                        )
                      )
                ),
                //Derecha
                Expanded(
                  flex: 1,
                  child: Container(
                  color: const Color.fromARGB(255, 92, 141, 163),
                  margin: EdgeInsets.only(top: 16.0, bottom: 16.0,left: 0.0, right: 16),
                  padding: EdgeInsets.all(11.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                    DropdownCatalogo(
                    label: 'Área',
                    items: catalogos.areas,
                    selectedId: idArea,
                    onChanged: (value) => setState(() => idArea = value),
                    ),                             
                    DropdownCatalogo(
                    label: 'Puesto',
                    items: catalogos.puestos,
                    selectedId: idPuesto,
                    onChanged: (value) => setState(() => idPuesto = value),
                    ),
                    Container(margin: EdgeInsets.only(top: 10), color:Colors.blue[50], child: 
                  fechaField("Fecha de alta", fechaRegistro, (fecha) => setState(() => fechaRegistro = fecha), context)),
                    customcard(
                      myElevatedB("Generar contraseña @", (){
                      final area = catalogos.areas.firstWhere((area) => int.parse(area.id) == idArea).nombre;
                      final nuevaPassword = generarPasswordDesdeArea(area);
                      setState(() => passwordController.text = nuevaPassword);}),
                    ),
                    customcard(
                       myElevatedB("Asignar equipo", () async {
                      equipo = await showSearch(
                        context: context,
                        delegate: BusquedaEquipoDelegate(equiposStock));
                        equipo!.numeroSerie!.isNotEmpty? {
                        setState(() {equipoCtrl.text = equipo!.numeroSerie!;})} : {null};}),
                    ),
                      customcard(
                        myElevatedB("Generar usuario(NAS)", () async {
                        final area = catalogos.areas.firstWhere((area) => int.parse(area.id) == idArea).nombre;
                        final nombreNAS = generarUsuarioNas(namelCtrl.text,lastNamelCtrl.text,catalogos,area, usuariosActivos );
                        setState(() {nasCtrl.text = nombreNAS;});}),
                      ),
                      customcard(myElevatedB("Registrar usuario", () async {await  buildUser(catalogos);}))
                    ])))
        ]
      )
    );
  }

   customcard(Widget widget){
    return SizedBox(
      width: double.infinity,
      child: widget,
    );}
   
   buildUser(catalogos) async {
    final ok = await registrarUser(context,"Registrando Usuario",idOperativa.toString(),idSede.toString(),fecha,idArea.toString(),idPuesto.toString(),namelCtrl.text,lastNamelCtrl.text,phoneCtrl.text,"~",equipoCtrl.text,"ACTIVO","~",nasCtrl.text,correoController.text,passwordController.text,"~","",[equipo!], catalogos);
    
    if(ok == "OK"){
    final operativa = catalogos.operativas.firstWhere((operativa) => int.parse(operativa.id) == idOperativa).nombre;
    final area = catalogos.areas.firstWhere((area) => int.parse(area.id) == idArea).nombre;
    final puesto = catalogos.puestos.firstWhere((puesto) => int.parse(puesto.id) == idPuesto).nombre;
    final sede = catalogos.sedes.firstWhere((sede) => int.parse(sede.id) == idSede).nombre;
    Usuario usuario = Usuario(operativa: operativa, sede: sede, ingreso: fecha, area: area, puesto: puesto, nombres: namelCtrl.text, 
    apellidos: lastNamelCtrl.text, contacto: phoneCtrl.text, notas: "", snEquipo: equipoCtrl.text, estado: "ACTIVO", baja: "", equipos: [equipo!], correo: correoController.text);
    
    generarPdfIngreso(context, usuario, "Generando PDF...", 0);
    resetDatos();
    }else{
      LoggerService.write("No se pudo impiar los datos $ok");
    }
     }

    resetDatos() {
      namelCtrl.clear();
      lastNamelCtrl.clear();
      correoController.clear();
      passwordController.clear();
      phoneCtrl.clear();
      equipoCtrl.clear();
      nasCtrl.clear();
  }

}

