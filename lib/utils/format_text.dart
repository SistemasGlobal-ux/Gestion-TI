String formatearTexto(String texto) {
  // Quitar espacios extra
  texto = texto.trim();

  // Pasar todo a minúsculas
  texto = texto.toLowerCase();

  // Eliminar puntos o comas al final
  texto = texto.replaceAll(RegExp(r'[.,]+$'), '');

  // Poner primera letra en mayúscula
  if (texto.isNotEmpty) {
    texto = texto[0].toUpperCase() + texto.substring(1);
  }

  return texto;
}
