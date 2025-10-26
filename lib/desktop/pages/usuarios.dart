

import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/desktop/pages/add_usuario.dart';
import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/modelos%20pdfs/modelos_pdf.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:application_sop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}


class _UsuariosPageState extends State<UsuariosPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Usuario> usuariosActivos = Provider.of<UsuariosListProvider>(context).users;

    final List<Usuario> usuariosFiltrados = usuariosActivos.where((u) {
      final query = _filtro.toLowerCase();
      return u.nombres.toLowerCase().contains(query) ||
             u.apellidos.toLowerCase().contains(query) ||
             u.area.toLowerCase().contains(query) ||
             u.puesto.toLowerCase().contains(query) ||
             u.correo!.toLowerCase().contains(query) || u.snEquipo.toLowerCase().contains(query);
    }).toList();

    TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: const Text(
                  'Usuarios',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              tecnico.rol == "admin" || tecnico.rol == "tecnico"? 
              iconButtonSingle("Importar usuarios de excel", Icons.import_export, Colors.blueGrey, (){})
              :Container(),
              iconButtonSingle("Exportar usuarios a excel", Icons.import_contacts_rounded, Colors.lightGreen,() => exportUsersToExcel(usuariosActivos,"Activos","Generando Excel...", context)),
              iconButtonSingle("Exportar usuarios a pdf", Icons.picture_as_pdf_rounded, Colors.redAccent,() => exportUsuariosToPDF(usuariosActivos, "Creando PDF...", context) ),
            ],
          ),
          const SizedBox(height: 10),
          //Campo de búsqueda
          Row(
            children: [
              Expanded(
                flex: 6,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, área o correo',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filtro = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 15),
              tecnico.rol == "admin" || tecnico.rol == "tecnico" ? 
              Expanded(
                flex: 1,
                child: iconButtonCustom("Nuevo usuario",  Icons.person, (){
                  Navigator.push(context,MaterialPageRoute(builder: (_) => Add_usuario()));
                })) : Container()
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: usuariosFiltrados.isEmpty
                ? const Center(
                    child: Text('No se encontraron resultados'),
                  )
                : ListView.builder(
                    itemCount: usuariosFiltrados.length,
                    itemBuilder: (context, index) {
                      final user = usuariosFiltrados[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        color: Colors.grey[300],
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 9),
                        child: ListTile(
                          onTap: (){
                            showInfoUser(context, user);
                          },
                          leading: CircleAvatar(backgroundColor: myColor(user.area), child: Icon(Icons.person, color: Colors.white, size: 30)),
                          title: Text(user.nombres,style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: 
                          Column( 
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(user.area, style: TextStyle(fontSize: 12)),
                            tecnico.rol == "admin" ?
                            Text('${user.correo} - ${user.psw!}')
                            : Text('${user.correo}'),
                          ]) ,
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              rowIcons(tecnico.rol, user, context)
                            ],
                          )
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


rowIcons(rol, user, context){
  return 
  rol == "admin" || rol == "tecnico"?
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      iconButtonSingle("PDF Equipo", Icons.picture_as_pdf, Colors.lightBlue, (){
        if(user.equipos!.length > 1){
          showListEquipos(context, user.equipos,(i){
            generarPdfIngreso(context, user, "Generando PDF...", i);
          });
        }else if (user.equipos!.length == 1){
         generarPdfIngreso(context, user, "Generando PDF...", 0);
        }
      }),
      iconButtonSingle("PDF Preventivo", Icons.build_circle, Colors.green.shade700, (){
        if(user.equipos!.length > 1){
          showListEquipos(context, user.equipos,(i){
            pdfMantPrevEquipo(user, user.equipos[i], context);
          });
        }else if (user.equipos!.length == 1){
        pdfMantPrevEquipo(user, user.equipos[0], context);
        }
      }),
      
      iconButtonSingle("PDF Correctivo", Icons.home_repair_service_outlined, Colors.orange.shade700, (){
        if(user.equipos!.length > 1){
          showListEquipos(context, user.equipos,(i){
            pdfMantCorretEquipo(user, user.equipos[i], context);
          });
        }else if (user.equipos!.length == 1){
        pdfMantCorretEquipo(user, user.equipos[0], context);
        }
      }),
      //iconButtonSingle("Responsiva a terceros", Icons.assignment_ind_outlined, Colors.teal.shade700, (){}),
      //pdfEntregaEquipoTerceros(usuario, equipo, context);
      SizedBox(width: 15),
      iconButtonSingle("Eliminar usuario", Icons.delete, Colors.redAccent, () async{
      generarPdfBaja(context, "Generando PDF...", user);
      }),
    ],
   ) :
   iconButtonSingle("Equipos", Icons.desktop_mac, Colors.greenAccent, (){
    if(user.equipos!.length >= 1){
          showEquipos(context, user);
        }
   });
}
