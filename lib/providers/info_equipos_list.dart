
import 'package:application_sop/maps/general_equipos.dart';
import 'package:application_sop/providers/info_eqipos_db_conexion.dart';
import 'package:flutter/material.dart';

class CatalogosEquiposListProvider extends ChangeNotifier{
  CatalogosE catalogosE = CatalogosE.empty();

  loadCatalogosEqipos() async {
    final catalogosE = await DBProviderCatalogosEquipos.db.getCatalogosE();
    this.catalogosE = catalogosE;
    notifyListeners();
  }
}