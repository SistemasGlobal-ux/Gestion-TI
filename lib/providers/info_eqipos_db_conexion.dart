import 'dart:convert';

import 'package:application_sop/maps/general_equipos.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/urls.dart';
import 'package:http/http.dart' as http;

class DBProviderCatalogosEquipos {
  static final DBProviderCatalogosEquipos db = DBProviderCatalogosEquipos._();
  DBProviderCatalogosEquipos._();

    Future getCatalogosE() async {
      final response = await http.get(myUrls("GENERALE"));
          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);
            return CatalogosE.fromJson(jsonData);
          }else{
            LoggerService.write("Error al cargar los catálogos ${response.statusCode}");
          }
    }
}

