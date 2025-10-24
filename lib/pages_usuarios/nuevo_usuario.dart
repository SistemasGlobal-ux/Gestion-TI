// ignore_for_file: library_private_types_in_public_api
import 'package:application_sop/busqueda_delegates/custom_search_equipo.dart';
import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/correos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/general.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/services/fetch_data.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/utils/custom_imput.dart';
import 'package:application_sop/utils/dropdow.dart';
import 'package:application_sop/utils/generar_passw.dart';
import 'package:application_sop/utils/generar_user_nas.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';

class AgregarUsuario extends StatefulWidget {
  const AgregarUsuario({super.key});

  @override
  _AgregarUsuarioState createState() => _AgregarUsuarioState();
}

class _AgregarUsuarioState extends State<AgregarUsuario> {
  String fecha = myDate(DateTime.now());
  int? idArea, idSede, idPuesto, idOperativa;
  String dominioSeleccionado = '@administracionglobal.mx';
  Equipo? equipo;

  final TextEditingController namelCtrl = TextEditingController();
  final TextEditingController lastNamelCtrl = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController equipoCtrl = TextEditingController();
  final TextEditingController nasCtrl = TextEditingController();
  final List<String> dominios = [
    '@administracionglobal.mx',
    '@marez.com.mx',
  ];

  late Future<Catalogos> futureCatalogos;
  late Future<List<Equipo>> futureEquipos;
  late Future<List<Correos>> futureMails;
  late Future<Map<String, List<Usuario>>?>? usuariosPorArea;

  Map<String, int> contadorAreas = {};

  @override
  void initState() {
    super.initState();
    futureCatalogos = fetchCatalogos();
    futureEquipos = fetchEquipos();
    futureMails = fetchMails();
    usuariosPorArea = fetchUsuariosArea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text('AGREGAR USUARIO'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Catalogos>(
          future: futureCatalogos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            
            final catalogos = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownCatalogo(
                    label: 'Operativa',
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
                  const SizedBox(height: 20),
                  CustomImput(
                    placeholder: "NOMBRE(S)",
                    textControler: namelCtrl,
                  ),
                  CustomImput(
                    placeholder: "APELLIDO(S)",
                    textControler: lastNamelCtrl,
                  ),
                  CustomImput(
                    placeholder: "CONTACTO",
                    textControler: phoneCtrl,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      myTextfield("USUARIO NAS", nasCtrl),
                      const SizedBox(width: 8),
                      myCustomB(
                        myElevatedB("GENERAR USUARIO-NAS", () async {
                        final dataAreas = await usuariosPorArea;
                        final nombreNAS = generarUsuarioNas(namelCtrl.text,lastNamelCtrl.text,catalogos,dataAreas,idArea);
                        setState(() =>
                          nasCtrl.text = nombreNAS
                          );
                        }),
                        0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Usuario
                      myTextfield("E-mail", usuarioController),
                      const SizedBox(width: 8),
                      // Dominio
                      myCustomB(
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            value: dominioSeleccionado,
                            items:
                                dominios
                                    .map(
                                      (d) => DropdownMenuItem(
                                        value: d,
                                        child: Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          d),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (valor) {
                              if (valor != null) {
                                setState(() => dominioSeleccionado = valor);
                              }
                            },
                          ),
                        ),
                        20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Contraseña
                      myTextfield('contraseña' ,passwordController),
                      const SizedBox(width: 8),
                      // Botón generar
                      myCustomB(
                        myElevatedB("GENERAR CONTRASEÑA", (){
                          final area = catalogos.areas.firstWhere((area) => int.parse(area.id) == idArea).nombre;
                          final nuevaPassword = generarPasswordDesdeArea(area);
                          setState(() => passwordController.text = nuevaPassword);
                        }),
                        0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      myTextfield("Equipo", equipoCtrl),
                      const SizedBox(width: 8),
                      myCustomB(
                        myElevatedB("ASIGNAR EQUIPO", () async {
                         final lista = await futureEquipos;
                         equipo = await showSearch(
                              // ignore: use_build_context_synchronously
                          context: context,
                          delegate: BusquedaEquipoDelegate(lista));
                          equipo!.numeroSerie!.isNotEmpty? {
                          setState(() {equipoCtrl.text = equipo!.numeroSerie!;}),
                                }
                                : {null};
                        }),
                        0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      myCustomB(myElevatedB("REGISTRAR", () async {
                      final ok = registrarUser(
                        context, 
                        "Registrando Usuario",
                         idOperativa.toString(),
                         idSede.toString(),
                         fecha,
                         idArea.toString(),
                         idPuesto.toString(),
                         namelCtrl.text,
                         lastNamelCtrl.text,
                         phoneCtrl.text,
                         "~",
                         equipoCtrl.text,
                         "ACTIVO",
                         "~",
                         nasCtrl.text,
                         usuarioController.text,
                         passwordController.text,
                         "~",
                         "",
                         [equipo!],
                         catalogos
                         );
                      resetDatos(ok);
                    }), 0)
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  resetDatos(data) {
    if (data == "OK") {
      namelCtrl.clear();
      lastNamelCtrl.clear();
      usuarioController.clear();
      passwordController.clear();
      phoneCtrl.clear();
      equipoCtrl.clear();
      nasCtrl.clear();
    } else {
    LoggerService.write("No se pudo impiar los datos $data");
    }
  }
}
