import 'package:flutter/material.dart';

myColor(String selectColor) {
  var colorArea = {
    "CONTABILIDAD": Color.fromARGB(255, 177, 187, 42),
    "JURIDICO": Color.fromARGB(255, 120, 200, 110),
    "TESORERIA": Color.fromARGB(255, 241, 158, 133),
    "OPERACIONES": Color.fromARGB(255, 96, 142, 222),
    "DIRECCION": Color.fromARGB(255, 145, 131, 50),
    "MATERIALIDAD": Color.fromARGB(255, 243, 231, 162),
    "CORPORATIVO": Color.fromARGB(255, 163, 152, 255),
    "RRHH": Color.fromARGB(255, 104, 245, 250),
    "BAJA": Color.fromARGB(255, 253, 97, 97),
    "SISTEMAS": Color.fromARGB(255, 0, 255, 76),
    "IMSS": Color.fromARGB(255, 119, 245, 213),
    "RECEPCIÓN": Color.fromARGB(255, 250, 210, 80),
    "COORDINADOR": Color.fromARGB(255, 252, 150, 230),
    "ENTREGADO": Color.fromARGB(255, 120, 200, 110),
    "STOCK": Color.fromARGB(255, 227, 233, 141),
    "DAÑADO": Color.fromARGB(255, 240, 65, 65),
    "POR DEFINIR": Color.fromARGB(255, 107, 211, 252),
    "": Color.fromARGB(255, 59, 200, 255),
  };
  Color colorDefault = Colors.white54;
  return colorArea[selectColor] ?? colorDefault;
}

