
import 'package:application_sop/maps/maps.dart';
import 'package:application_sop/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

void editUsuario(BuildContext context, Usuario usuario) {

  final Catalogos catalogos = Provider.of<CatalogosListProvider>(context, listen: false).catalogos;
  int? sedeID, areaID, puestoID;

  final TextEditingController ingresoCtrl = TextEditingController(text: usuario.ingreso);
  final TextEditingController nombreCtrl = TextEditingController(text: usuario.nombres);
  final TextEditingController apellidoCtrl = TextEditingController(text: usuario.apellidos);
  final TextEditingController contactoCtrl = TextEditingController(text: usuario.contacto);
  final TextEditingController mailCtrl = TextEditingController(text: usuario.correo);
  final TextEditingController notasCtrl = TextEditingController(text: usuario.notas);

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
                child: Text('Editar usuario',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 16),
              // Campos editables
              listGeneral("Sede", catalogos.sedes, idSedeMap[usuario.sede], (value){ sedeID = value;}),
              listGeneral("Area", catalogos.areas, idAreaMap[usuario.area], (value){areaID = value;}),
              listGeneral("Puesto", catalogos.puestos, idPuestoMap[usuario.puesto], (value){puestoID = value;}),
              TextField(
                controller: ingresoCtrl,
                decoration: InputDecoration(labelText: 'Fecha de ingreso'),
              ),
              TextField(
                controller: nombreCtrl,
                decoration: InputDecoration(labelText: 'Nombre(s)'),
              ),
              TextField(
                controller: apellidoCtrl,
                decoration: InputDecoration(labelText: 'Apellidos'),
              ),
              TextField(
                controller: contactoCtrl,
                decoration: InputDecoration(labelText: 'Contacto'),
              ),
              TextField(
                controller: mailCtrl,
                decoration: InputDecoration(labelText: 'Correo'),
              ),
              TextField(
                controller: notasCtrl,
                decoration: InputDecoration(labelText: 'Notas'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  iconButtonCustom("Cancelar", Icons.cancel, ()=> Navigator.pop(context)),
                  iconButtonCustom("Guardar", Icons.save, (){
                    print(sedeID); print(areaID); print(puestoID);
                    print(usuario);
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