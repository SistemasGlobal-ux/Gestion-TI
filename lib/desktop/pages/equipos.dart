
import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/equipos.dart';
import 'package:application_sop/maps/tech_suppor.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:application_sop/providers/equipos_list.dart';
import 'package:application_sop/providers/tech_support_list.dart';
import 'package:application_sop/providers/usuarios_list.dart';
import 'package:application_sop/utils/colors_area.dart';
import 'package:application_sop/utils/personalizados.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquiposPage extends StatefulWidget {
  const EquiposPage({super.key});
  @override
  State<EquiposPage> createState() => EquipiosPageState();
}

class EquipiosPageState extends State<EquiposPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<EquiposListProvider>(context).loadAllEquipos();
    List<Equipo> allEquipos =  Provider.of<EquiposListProvider>(context).todosLosEquipos;
        final List<Usuario> usuariosActivos = Provider.of<UsuariosListProvider>(context).users;

    final List<Equipo> equiposFiltrados = allEquipos.where((e) {
      final query = _filtro.toLowerCase();
      return e.numeroSerie!.toLowerCase().contains(query) ||
             e.marca!.toLowerCase().contains(query) ||
             e.modelo!.toLowerCase().contains(query) ||
             e.nas!.toLowerCase().contains(query);
    }).toList();

    TechSuppor tecnico = Provider.of<TechSupporListProvider>(context, listen: false).tecnico;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: const Text(
                  'Equipos',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              tecnico.rol == "admin" || tecnico.rol == "tecnico"? 
              iconButtonSingle("Importar equipos de excel", Icons.import_export, Colors.blueGrey, (){})
              :Container(),
              iconButtonSingle("Exportar equipos a excel", Icons.import_contacts_rounded, Colors.lightGreen, () => exportEquiposToExcel(allEquipos, usuariosActivos, "Exportando equipos...", context)),
              iconButtonSingle("Exportar equipos a pdf", Icons.picture_as_pdf_rounded, Colors.redAccent,() => exportEquiposToPDF(allEquipos, "Creando PDF...", context)),
            ],
          ),
          const SizedBox(height: 20),
          //Campo de búsqueda
          Row(
            children: [
              Expanded(
                flex: 6,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Buscar por marca, modelo o numero de serie',
                    prefixIcon: const Icon(Icons.search),
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
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: iconButtonCustom("Nuevo equipo",  Icons.laptop, (){}))
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: equiposFiltrados.isEmpty
                ? const Center(
                    child: Text('No se encontraron resultados'),
                  )
                : ListView.builder(
                    itemCount: equiposFiltrados.length,
                    itemBuilder: (context, index) {
                      final equipo = equiposFiltrados[index];
                      return Card(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 9),
                        child: ListTile(
                          onTap: (){ print(equipo); },
                          leading: CircleAvatar(backgroundColor: myColor(equipo.estado!), child: Icon(Icons.computer, color: Colors.white,size: 30)),
                          title: Text("${equipo.marca} - ${equipo.modelo}",style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(equipo.estado!),
                              Text(equipo.numeroSerie!),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              rowIcons(tecnico.rol)
                            ],
                          ),
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

rowIcons(rol){
  return 
  rol == "admin" || rol == "tecnico"?
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      iconButtonSingle("Editar equipo", Icons.edit, Colors.blue, (){}),
      iconButtonSingle("Asignar equipo", Icons.assignment_add, const Color.fromARGB(255, 81, 156, 75), (){}),
      SizedBox(width: 15),
      iconButtonSingle("Eliminar equipo", Icons.delete, Colors.redAccent, (){}),
    ],
   ) :
   Container();
}

