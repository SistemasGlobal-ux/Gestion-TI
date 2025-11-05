


import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';

void editEquipo(BuildContext context, Equipo equipo) {

  final Catalogos catalogos = Provider.of<CatalogosListProvider>(context, listen: false).catalogos;
  int? sedeID;

  final TextEditingController marcaCtrl = TextEditingController(text: equipo.marca);
  final TextEditingController snCtrl = TextEditingController(text: equipo.numeroSerie);
  final TextEditingController nasCtrl = TextEditingController(text: equipo.nas);
  final TextEditingController dpCtrl = TextEditingController(text: equipo.discoPrincipal);
  final TextEditingController dsCtrl = TextEditingController(text: equipo.discoSecundario);
  final TextEditingController ramCtrl = TextEditingController(text: equipo.ram);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Editar equipo',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 16),
              // Campos editables
              listGeneral("Sede", catalogos.sedes, idSedeMap[equipo.sede], (value){sedeID = value;}),
              TextField(
                controller: marcaCtrl,
                decoration: InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: snCtrl,
                decoration: InputDecoration(labelText: 'ns'),
              ),
              TextField(
                controller: nasCtrl,
                decoration: InputDecoration(labelText: 'Nas'),
              ),
              TextField(
                controller: dpCtrl,
                decoration: InputDecoration(labelText: 'Disco principal'),
              ),
              TextField(
                controller: dsCtrl,
                decoration: InputDecoration(labelText: 'Disco secundario'),
              ),
              TextField(
                controller: ramCtrl,
                decoration: InputDecoration(labelText: 'Ram'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  iconButtonCustom("Cancelar", Icons.cancel, () => Navigator.pop(context)),
                  iconButtonCustom("Guardar", Icons.save, (){
                    //TODO: agregar editar equipo en db
                    }),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}


   Widget listGeneral(
    String label,
    List<CatalogoItem> items,
    int? selectedId,
  ValueChanged<int?> onChanged,
  ) {
  return Container(
    margin: const EdgeInsets.only(top: 10, bottom: 10),
    child: DropdownCatalogo(
      label: label,
      items: items,
      selectedId: selectedId,
      onChanged: onChanged, // delega el cambio
    ),
  );
}