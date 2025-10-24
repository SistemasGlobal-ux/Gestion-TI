


import 'package:application_sop/busqueda_delegates/custom_search_equipo.dart';
import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/general.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/providers/equipos_list.dart';
import 'package:application_sop/providers/general_list.dart';
import 'package:application_sop/providers/usuarios_list.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/utils/custom_imput.dart';
import 'package:application_sop/utils/dropdow.dart';
import 'package:application_sop/utils/generar_passw.dart';
import 'package:application_sop/utils/generar_user_nas.dart';
import 'package:application_sop/utils/personalizados.dart';
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
  final TextEditingController lastNamelCtrl = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController equipoCtrl = TextEditingController();
  final TextEditingController nasCtrl = TextEditingController();

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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            //izquierda
                            Expanded(
                              flex: 2,
                              child: Column( 
                                children: [
                              _customcard([
                               Row(children: [Text("Datos del colaborador")]),
                               CustomImput(placeholder: "Nombres(s)",textControler: namelCtrl),
                               CustomImput(placeholder: "Apellidos", textControler: lastNamelCtrl),
                               CustomImput(placeholder: "Contacto",textControler: phoneCtrl),
                              ]),
                              _customcard([
                                Row(children: [Text("asignacion de correo")]),
                                const SizedBox(height: 15),
                                CustomImput(placeholder: "Correo", textControler: correoController),
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
                                SizedBox(height: 20),
                                CustomImput(placeholder: 'contraseña' ,textControler:  passwordController),
                                ]),
                              _customcard([
                                Row(children: [Text("Asignacion de equipo")]),
                              CustomImput(placeholder:  "Equipo", textControler:  equipoCtrl),
                              CustomImput(placeholder:  "Usuario NAS", textControler:  nasCtrl),
                              ]),
                                      ],
                                    ),
                            ),
                             //derecha
                            Expanded(
                              flex: 1,
                              child: Column(
                               children: [
                                 _customcard([
                                  DropdownCatalogo(label: 'Operativa',
                                  items: catalogos.operativas,
                                  selectedId: idOperativa,
                                  onChanged: (value) => setState(() => idOperativa = value),
                                  ),
                                  ]),
                                 _customcard([DropdownCatalogo(
                    label: 'Sede',
                    items: catalogos.sedes,
                    selectedId: idSede,
                    onChanged: (value) => setState(() => idSede = value),
                  )]),
                                 _customcard([
                  DropdownCatalogo(
                    label: 'Área',
                    items: catalogos.areas,
                    selectedId: idArea,
                    onChanged: (value) => setState(() => idArea = value),
                  ),
                                 ]),
                                 _customcard([
                  DropdownCatalogo(
                    label: 'Puesto',
                    items: catalogos.puestos,
                    selectedId: idPuesto,
                    onChanged: (value) => setState(() => idPuesto = value),
                  ),
                                 ]),
                                 _customcard([
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text("Fecha: $fecha")])]),
                                 _customcard([
                                  Row(
                                    children: [
                                      Expanded(
                                        child: myElevatedB("Generar contraseña @", (){
                                        final area = catalogos.areas.firstWhere((area) => int.parse(area.id) == idArea).nombre;
                                        final nuevaPassword = generarPasswordDesdeArea(area);
                                        setState(() => passwordController.text = nuevaPassword);}),
                                      ),
                                    ],
                                  )
                                 ]),
                                 _customcard([
                                  Row(
                                    children: [
                                      Expanded(
                                        child: myElevatedB("Asignar equipo", () async {
                                    equipo = await showSearch(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      delegate: BusquedaEquipoDelegate(equiposStock));
                                      equipo!.numeroSerie!.isNotEmpty? {
                                      setState(() {equipoCtrl.text = equipo!.numeroSerie!;}),
                                       } : {null};}
                                       )
                                      ),
                                    ],
                                  )
                                 ]),
                                 _customcard([
                                   Row(
                                    children: [
                                      Expanded(
                                        child: myElevatedB("Generar usuario(NAS)", () async {
                                   final area = catalogos.areas.firstWhere((area) => int.parse(area.id) == idArea).nombre;
                                   final nombreNAS = generarUsuarioNas(namelCtrl.text,lastNamelCtrl.text,catalogos,area, usuariosActivos );
                                   setState(() {nasCtrl.text = nombreNAS;});})
                                      ),
                                    ],
                                  )
                                 ]),
                                 _customcard([
                                   Row(
                                    children: [
                                      Expanded(
                                        child: myElevatedB("Registrar usuario", () async {await  buildUser(catalogos);})
                                      ),
                                    ],
                                  )
                                 ]),
                                ],
                               ),
                              )
                          ],
                        )
                      )
                    ],
                  ),
                )
                )
        ]
      )
    );
  }

  _customcard(List<Widget> column){
    return Expanded(
      child: Card(
        color: const Color.fromARGB(255, 92, 141, 163),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(11.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: column),
               ),
           )
        );
 }
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

