import 'dart:convert';

import 'package:application_sop/services/urls.dart';
import 'package:http/http.dart' as http;

class DBProvider365 {
  static final DBProvider365 db = DBProvider365._();
  DBProvider365._();

  Future getCuentas() async {}

  Future addCuenta(body) async {
    var res = await http.post(myUrls("ADDMAIL"), headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
    final response = jsonDecode(res.body);
    if (response["status"] == true) {
    String idEmail = response['id_mail'];
    return idEmail;
    }else{
      return response["status"];
    }
  }

  Future delete365(body) async {
    await http.post(myUrls("DELETEMAIL"), headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
  }

  }