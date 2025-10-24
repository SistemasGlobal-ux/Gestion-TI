

import 'package:application_sop/cargas/generar_archivos.dart';
import 'package:application_sop/maps/usuarios.dart';
import 'package:flutter/material.dart';

void formularioResponsiva(BuildContext context, Usuario usuario) {
  final TextEditingController especificacionesCtrl = TextEditingController();
  final TextEditingController marcaModeloCtrl = TextEditingController();
  final TextEditingController nsCtrl = TextEditingController();

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Responsiva detallada',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: especificacionesCtrl,
                decoration: InputDecoration(labelText: 'Especificaciones'),
              ),
              TextField(
                controller: marcaModeloCtrl,
                decoration: InputDecoration(labelText: 'Marca / Modelo'),
              ),
              TextField(
                controller: nsCtrl,
                decoration: InputDecoration(labelText: 'N° de Serie'),
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
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text('Generar PDF'),
                    onPressed: () {
                      final especificaciones = especificacionesCtrl.text.trim();
                      final marcaModelo = marcaModeloCtrl.text.trim();
                      final ns = nsCtrl.text.trim();

                      if (especificaciones.isEmpty || marcaModelo.isEmpty || ns.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Completa todos los campos')),
                        );
                        return;
                      }

                      generarResponsivaExt(context,usuario,"Generando PDF...", especificacionesCtrl.text, marcaModeloCtrl.text, nsCtrl.text);

                      Navigator.pop(context); // cerrar modal
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
