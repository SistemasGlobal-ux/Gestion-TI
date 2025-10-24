import 'dart:math';

String generarPasswordDesdeArea(String area) {
  final caracteres = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();

  String inicial = area.trim().toUpperCase().substring(0, 1);
  String aleatorios =
      List.generate(
        4,
        (_) => caracteres[random.nextInt(caracteres.length)],
      ).join();
  String year = DateTime.now().year.toString().substring(2);

  return '$inicial.$aleatorios\$$year';
}
