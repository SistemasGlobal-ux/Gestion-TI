// ignore_for_file: file_names

import 'package:syncfusion_flutter_pdf/pdf.dart';

PdfBorders bordes = PdfBorders(
  left: PdfPen(PdfColor(0, 0, 0)),
  right: PdfPen(PdfColor(0, 0, 0)),
  top: PdfPen(PdfColor(0, 0, 0)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders sinB = PdfBorders(
  left: PdfPen(PdfColor(300, 300, 300)),
  right: PdfPen(PdfColor(300, 300, 300)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(300, 300, 300)),
);

PdfBorders onlitop = PdfBorders(
  left: PdfPen(PdfColor(300, 300, 300)),
  right: PdfPen(PdfColor(300, 300, 300)),
  top: PdfPen(PdfColor(0, 0, 0)),
  bottom: PdfPen(PdfColor(300, 300, 300)),
);

PdfBorders onliTB = PdfBorders(
  left: PdfPen(PdfColor(300, 300, 300)),
  right: PdfPen(PdfColor(300, 300, 300)),
  top: PdfPen(PdfColor(0, 0, 0)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders onliL = PdfBorders(
  left: PdfPen(PdfColor(0, 0, 0)),
  right: PdfPen(PdfColor(300, 300, 300)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(300, 300, 300)),
);

PdfBorders onliR = PdfBorders(
  left: PdfPen(PdfColor(300, 300, 300)),
  right: PdfPen(PdfColor(0, 0, 0)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(300, 300, 300)),
);

PdfBorders onliBu = PdfBorders(
  left: PdfPen(PdfColor(300, 300, 300)),
  right: PdfPen(PdfColor(300, 300, 300)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders onliLR = PdfBorders(
  left: PdfPen(PdfColor(0, 0, 0)),
  right: PdfPen(PdfColor(0, 0, 0)),
  top: PdfPen(PdfColor(300, 300, 300), width: 0),
  bottom: PdfPen(PdfColor(300, 300, 300), width: 0),
);

PdfBorders onliLB = PdfBorders(
  left: PdfPen(PdfColor(0, 0, 0)),
  right: PdfPen(PdfColor(300, 300, 300)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders onliRB = PdfBorders(
  left: PdfPen(PdfColor(300, 300, 300)),
  right: PdfPen(PdfColor(0, 0, 0)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders onliLRB = PdfBorders(
  left: PdfPen(PdfColor(0, 0, 0)),
  right: PdfPen(PdfColor(0, 0, 0)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders onliLTB = PdfBorders(
  left: PdfPen(PdfColor(0, 0, 0)),
  right: PdfPen(PdfColor(210, 210, 210)),
  top: PdfPen(PdfColor(0, 0, 0)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders onliRTB = PdfBorders(
  left: PdfPen(PdfColor(210, 210, 210)),
  right: PdfPen(PdfColor(0, 0, 0)),
  top: PdfPen(PdfColor(0, 0, 0)),
  bottom: PdfPen(PdfColor(0, 0, 0)),
);

PdfBorders allBlue = PdfBorders(
  left: PdfPen(PdfColor(142, 170, 219)),
  right: PdfPen(PdfColor(142, 170, 219)),
  top: PdfPen(PdfColor(142, 170, 219)),
  bottom: PdfPen(PdfColor(142, 170, 219)),
);

PdfBorders allgray = PdfBorders(
  left: PdfPen(PdfColor(225, 211, 211, 0)),
  right: PdfPen(PdfColor(225, 211, 211, 0)),
  top: PdfPen(PdfColor(300, 300, 300)),
  bottom: PdfPen(PdfColor(300, 300, 300)),
);

PdfBorders firmas = PdfBorders(
  left: PdfPen(PdfColor(300, 300, 300)),
  right: PdfPen(PdfColor(300, 300, 300)),
  top: PdfPen(PdfColor(142, 170, 219)),
  bottom: PdfPen(PdfColor(300, 300, 300)),
);

pdfCellStyle(
  double l,
  double r,
  double t,
  double b,
  PdfColor c,
  double s,
  PdfBorders bd,
  PdfBrush colorT,
) {
  return PdfGridCellStyle(
    borders: bd,
    backgroundBrush: PdfSolidBrush(c),
    cellPadding: PdfPaddings(left: l, right: r, top: t, bottom: b),
    font: PdfStandardFont(PdfFontFamily.helvetica, s, style: PdfFontStyle.bold),
    textBrush: colorT,
  );
}

pdfDatosStyle(PdfBorders b, double l, double r, double t, double bt) {
  return PdfGridCellStyle(
    cellPadding: PdfPaddings(left: l, right: r, top: t, bottom: bt),
    borders: b,
    font: PdfStandardFont(PdfFontFamily.helvetica, 8),
    textBrush: PdfSolidBrush(PdfColor(32, 32, 32)),
  );
}

pdfValidacionStyle(PdfBorders b, double n) {
  return PdfGridCellStyle(
    borders: b,
    font: PdfStandardFont(PdfFontFamily.helvetica, n),
    textBrush: PdfSolidBrush(PdfColor(32, 32, 32)),
  );
}

pdfStrAlin(PdfTextAlignment a) {
  return PdfStringFormat(
    alignment: a,
    lineAlignment: PdfVerticalAlignment.middle,
  );
}

titulo(PdfGridRow row, int i, String text, double textsize) {
  row.cells[i].value = text;
  row.cells[i].style = pdfCellStyle(
    0,
    0,
    2,
    2,
    PdfColor(255, 255, 255),
    textsize,
    sinB,
    PdfBrushes.black,
  );
  row.cells[i].stringFormat = pdfStrAlin(PdfTextAlignment.center);
}

miDatoList(PdfGridRow row, int i, String text, double left) {
  row.cells[i].value = text;
  row.cells[i].style = pdfDatosStyle(onliLR, left, 0, 2, 2);
  row.cells[i].stringFormat = pdfStrAlin(PdfTextAlignment.left);
}

celdaDato(PdfGridRow row, int i, String text, double textsize) {
  row.cells[i].value = text;
  row.cells[i].style = pdfCellStyle(
    0,
    0,
    2,
    2,
    PdfColor(210, 210, 210),
    textsize,
    bordes,
    PdfBrushes.black,
  );
  row.cells[i].stringFormat = pdfStrAlin(PdfTextAlignment.center);
}

celdaDatoStart(PdfGridRow row, int i, String text, double textsize){
    row.cells[i].value = text;
  row.cells[i].style = pdfCellStyle(
    0,
    0,
    2,
    2,
    PdfColor(210, 210, 210),
    textsize,
    bordes,
    PdfBrushes.black,
  );
  row.cells[i].stringFormat = pdfStrAlin(PdfTextAlignment.left);
}

celdaValor(PdfGridRow row, int i, String text) {
  row.cells[i].value = text;
  row.cells[i].style = pdfDatosStyle(bordes, 0, 0, 2, 2);
  row.cells[i].stringFormat = pdfStrAlin(PdfTextAlignment.center);
}

celdaValorStart(PdfGridRow row, int i, String text) {
  row.cells[i].value = text;
  row.cells[i].style = pdfDatosStyle(bordes, 0, 0, 2, 2);
  row.cells[i].stringFormat = pdfStrAlin(PdfTextAlignment.left);
}

saltoDeCelda(PdfGridRow row, int columns) {
  row.cells[0].columnSpan = columns;
  row.cells[0].value = " ";
  row.cells[0].style = pdfDatosStyle(onliTB, 0, 0, 2, 2);
  row.cells[0].stringFormat = pdfStrAlin(PdfTextAlignment.center);
}

saltoDeCeldaSB(PdfGridRow row, int columns) {
  row.cells[0].columnSpan = columns;
  row.cells[0].value = " ";
  row.cells[0].style = pdfDatosStyle(sinB, 0, 0, 2, 2);
  row.cells[0].stringFormat = pdfStrAlin(PdfTextAlignment.center);
}

celdaValorFecha(PdfGridRow row, int i, String text) {
  row.cells[i].value = text;
  row.cells[i].style = pdfCellStyle(
    0,
    5,
    2,
    2,
    PdfColor(210, 210, 210),
    8,
    bordes,
    PdfBrushes.black,
  );
  row.cells[i].stringFormat = pdfStrAlin(PdfTextAlignment.right);
}
