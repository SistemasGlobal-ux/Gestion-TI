import 'dart:convert';
import 'dart:io';
import 'package:application_sop/services/logger.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

saveFile(
  List<int> bytes,
  String documento,
  String carpeta,
  context,
  String formato,
) async {
  try {
    if (kIsWeb) {
      Uint8List uint8Bytes = Uint8List.fromList(bytes);
      await FileSaver.instance.saveFile(
        name: "$documento.$formato",
        bytes: uint8Bytes,
      );
    } else if (Platform.isWindows) {
      Directory documentsD = await getApplicationDocumentsDirectory();
      final Directory appDocDirFolder = Directory(
        '${documentsD.path}/PDFs_RJG/$carpeta',
      );
      await appDocDirFolder.create(recursive: true);
      String fileName =
          "${documentsD.path}/PDFs_RJG/$carpeta/$documento.$formato";
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      await OpenAppFile.open("${documentsD.path}/PDFs_RJG/$carpeta/");
      await OpenFile.open(fileName);
    } else if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final path = directory!.absolute.path;
      String fileName = "$path/$documento.$formato";
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(file.path);
    } else if (Platform.isIOS) {
      Directory documents = await getApplicationDocumentsDirectory();
      final path = documents.absolute.path;
      String fileName = "$path/$documento.$formato";
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(file.path);
    } else {}
  } catch (e) {
    LoggerService.write("$e");
  }
}

readFiles(String carpeta, context) async {
  try {
    if (Platform.isWindows) {
      Directory documentsD = await getApplicationDocumentsDirectory();
      final Directory appDocDirFolder = Directory(
        '${documentsD.path}/PDFs_RJG/$carpeta',
      );
      var path = appDocDirFolder.listSync();
      List pdfs = [];
      for (var i = 0; i < path.length; i++) {
        var fileName = (path[i].toString().split('\\').last);
        var pdf = jsonEncode({"name": fileName, "path": path[i].path});
        pdfs.add(pdf);
      }
      return pdfs;
    }
  } catch (e) {
    null;
  }
}

String obtenerMimeType(String formato) {
  switch (formato.toLowerCase()) {
    case 'pdf':
      return 'application/pdf';
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case 'txt':
      return 'text/plain';
    default:
      return 'application/octet-stream'; // binario genérico
  }
}
