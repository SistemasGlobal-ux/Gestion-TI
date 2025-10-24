import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static File? _logFile;
  static String? _today;

  /// Inicializa el archivo de log y configura captura de errores
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/app_log.txt';
    _logFile = File(path);

    // Fecha actual
    final now = DateTime.now();
    _today = "${now.year}-${now.month}-${now.day}";

    // Si no existe lo crea
    if (!await _logFile!.exists()) {
      await _logFile!.create();
    }

    // Limpiar si no corresponde al día actual
    final contenido = await _logFile!.readAsString();
    if (contenido.isNotEmpty && !contenido.contains("--- $_today ---")) {
      await _logFile!.writeAsString("");
    }

    await write("--- $_today --- App iniciada ---");

    // Capturar errores de Flutter
    FlutterError.onError = (FlutterErrorDetails details) async {
      await write("FlutterError: ${details.exceptionAsString()}");
      FlutterError.presentError(details);
    };

    // Capturar errores de Dart fuera del framework
    PlatformDispatcher.instance.onError = (error, stack) {
      write("Unhandled Dart Error: $error\nStack: $stack");
      return true; // evita que cierre la app
    };
  }

  /// Escribir en el log
  static Future<void> write(String message) async {
    if (_logFile == null) return;

    final now = DateTime.now();
    final fecha = "${now.year}-${now.month}-${now.day}";
    final hora =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    // Si cambió de día → limpiar
    if (fecha != _today) {
      _today = fecha;
      await _logFile!.writeAsString(""); // limpiar
      await _logFile!.writeAsString("--- $_today --- Nuevo día ---\n",
          mode: FileMode.append);
    }

    await _logFile!.writeAsString("[$hora] $message\n", mode: FileMode.append);
  }

  /// Leer log actual
  static Future<String> read() async {
    if (_logFile == null) return "";
    return await _logFile!.readAsString();
  }
}
