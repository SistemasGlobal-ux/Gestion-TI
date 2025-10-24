import 'dart:convert';

import 'package:application_sop/maps/general.dart';
import 'package:application_sop/services/logger.dart';
import 'package:application_sop/services/urls.dart';
import 'package:http/http.dart' as http;

class DBProviderCatalogos {
  static final DBProviderCatalogos db = DBProviderCatalogos._();
  DBProviderCatalogos._();

    Future getCatalogos() async {
      final response = await http.get(myUrls("GENERAL"));
          if (response.statusCode == 200) {
            final jsonData = jsonDecode(response.body);
            return Catalogos.fromJson(jsonData);
          }else{
            LoggerService.write("Error al cargar los catálogos ${response.statusCode}");
          }
    }


}