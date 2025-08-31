import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Impressão básica de uma tabela.
/// [title]: título no topo.
/// [columns]: cabeçalhos.
/// [data]: lista de itens.
/// [toRow]: como transformar um item em uma lista de strings (uma linha).
Future<void> printList<T>({
  required String title,
  required List<String> columns,
  required List<T> data,
  required List<String> Function(T item) toRow,
}) async {
  final doc = pw.Document();

  doc.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(margin: const pw.EdgeInsets.all(24)),
      build: (context) => [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.Table.fromTextArray(
          headers: columns,
          data: data.map(toRow).toList(),
          headerStyle: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
          ),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
          cellStyle: const pw.TextStyle(fontSize: 10),
          cellAlignment: pw.Alignment.centerLeft,
          headerAlignment: pw.Alignment.centerLeft,
          columnWidths: {
            // deixa a primeira coluna um pouco menor (ID)
            0: const pw.FlexColumnWidth(1.2),
          },
        ),
      ],
      footer: (context) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Página ${context.pageNumber} de ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ),
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => doc.save());
}
