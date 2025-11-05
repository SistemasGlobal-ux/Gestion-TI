

import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:application_sop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UsariosBPageAndroid extends StatefulWidget {
  List<Usuario> usuarios;
  UsariosBPageAndroid({super.key, required this.usuarios});

  @override
  State<UsariosBPageAndroid> createState() => _UsariosBPageAndroidState();
}

class _UsariosBPageAndroidState extends State<UsariosBPageAndroid> {
  final TextEditingController _searchController = TextEditingController();
  String filtro = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final List<Usuario> usuariosFiltrados = widget.usuarios.where((u) {
      final query = filtro.toLowerCase();
      return u.nombres.toLowerCase().contains(query) ||
             u.apellidos.toLowerCase().contains(query) ||
             u.area.toLowerCase().contains(query) ||
             u.puesto.toLowerCase().contains(query) ||
             u.correo!.toLowerCase().contains(query) || u.snEquipo.toLowerCase().contains(query);
    }).toList();

    TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;

    return Scaffold(
      appBar: AppBar(
       iconTheme: IconThemeData(color: Colors.white),
        backgroundColor:Color(0xFF111827),
        title: const Text('Usuarios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            actions: [
              tecnico.rol == "admin" || tecnico.rol == "tecnico"? 
              iconButtonSingle("Importar usuarios de excel", Icons.import_export, Colors.white, (){})
              :Container(),
              iconButtonSingle("Exportar usuarios a excel", Icons.import_contacts_rounded, Colors.lightGreen,() => exportUsersToExcel(widget.usuarios,"Activos","Generando Excel...", context)),
              iconButtonSingle("Exportar usuarios a pdf", Icons.picture_as_pdf_rounded, Colors.redAccent,() => exportUsuariosToPDF(widget.usuarios, "Creando PDF...", context) ),
            ],
      ),
      body: Container(
      margin: EdgeInsets.all(10),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Campo de búsqueda
          Row(
            children: [
              Expanded(
                flex: 4,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, área o correo',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: 
                    filtro.isNotEmpty ?
                    IconButton( 
                      onPressed: (){
                      setState(() {
                        _searchController.clear();
                        filtro = '';
                      });
                    }, 
                    icon: Icon(Icons.clear_outlined))
                    : null
                  ),
                  onChanged: (value) {
                    setState(() {
                      filtro = value;
                    });
                  },
                ),
              ),
            ],
          ),
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
                            //showInfoUser(context, user);
                            },
                          leading: CircleAvatar(backgroundColor: myColor(user.area), child: Icon(Icons.person, color: Colors.white, size: 30)),
                          title: Text(user.nombres,style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: 
                          Column( 
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(user.area, style: TextStyle(fontSize: 12)),
                            Text('${user.correo}'),
                            tecnico.rol == "admin" ?
                            Text(user.psw!) : Container(),
                          ]),
                          //trailing: Column(mainAxisAlignment: MainAxisAlignment.center,children: [rowIcons(tecnico.rol, user, context)])
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
    );
  }
}
