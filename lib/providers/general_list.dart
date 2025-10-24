

import 'package:application_sop/maps/general.dart';
import 'package:application_sop/providers/general_db_conexion.dart';
import 'package:flutter/material.dart';

class CatalogosListProvider extends ChangeNotifier{

   Catalogos catalogos = Catalogos.empty();

  loadCatalogos() async {
    final catalogos = await DBProviderCatalogos.db.getCatalogos();
    this.catalogos = catalogos;
    notifyListeners();
  }

}
