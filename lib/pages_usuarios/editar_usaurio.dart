
import 'package:application_sop/maps/usuarios.dart';
import 'package:flutter/material.dart';

void mostrarEditarUsuario(BuildContext context, Usuario usuario) {

  final TextEditingController puestoCtrl = TextEditingController(text: usuario.puesto);
  final TextEditingController contactoCtrl = TextEditingController(text: usuario.contacto);
  final TextEditingController notasCtrl = TextEditingController(text: usuario.notas);
  String estado = usuario.estado;
  
 //TODO: Agregar funciones de listas para modificar en DB
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
              TextField(
                controller: puestoCtrl,
                decoration: InputDecoration(labelText: 'Puesto'),
              ),
              TextField(
                controller: contactoCtrl,
                decoration: InputDecoration(labelText: 'Contacto'),
              ),
              TextField(
                controller: notasCtrl,
                decoration: InputDecoration(labelText: 'Notas'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: estado,
                items: ['ACTIVO', 'BAJA']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => estado = value!,
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text('Guardar'),
                    onPressed: () {
                      // Guardar cambios al usuario
                      Navigator.pop(context); // cerrar modal
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
