// ignore_for_file: file_names

import 'package:application_sop/maps/mails.dart';
import 'package:application_sop/providers/365_db_conexion.dart';
import 'package:flutter/material.dart';

class C365Listproviders extends ChangeNotifier{

  List<Mails> mails = [];

  new365(direccion, psw) async {
    final body = {'direccion' : direccion,'psw': psw};
    final new365 = await DBProvider365.db.addCuenta(body);
     return new365;
  }

  delete365(id365) async {
    final body = {'id' : id365};
    await DBProvider365.db.delete365(body);
  }


}