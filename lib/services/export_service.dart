import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Agregar este import
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  // Exportar dashboard como PDF - VERSIÓN CORREGIDA
  static Future<void> exportToPDF({
    required BuildContext context,
    required Map<String, dynamic> dashboardData,
  }) async {
    try {
      final pdf = pw.Document();

      // Crear páginas del PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              _buildPDFHeader(),
              pw.SizedBox(height: 20),
              _buildPDFExecutiveSummary(dashboardData),
              pw.SizedBox(height: 20),
              _buildPDFNoticiasMetrics(dashboardData),
              pw.SizedBox(height: 20),
              _buildPDFTareasMetrics(dashboardData),
              pw.SizedBox(height: 20),
              _buildPDFActivitySection(dashboardData),
            ];
          },
        ),
      );

      // Usar Printing plugin directamente (sin path_provider)
      final Uint8List pdfBytes = await pdf.save();

      // SOLUCIÓN: Usar Printing.sharePdf en lugar de path_provider
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename:
            'dashboard_manazco_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      throw Exception('Error generando PDF: $e');
    }
  }

  // Exportar dashboard como Excel - VERSIÓN CORREGIDA
  static Future<void> exportToExcel({
    required BuildContext context,
    required Map<String, dynamic> dashboardData,
  }) async {
    try {
      final excel = Excel.createExcel();

      // Eliminar hoja por defecto
      excel.delete('Sheet1');

      // Crear hojas del reporte
      _createDashboardSheet(excel, dashboardData);
      _createNoticiasSheet(excel, dashboardData);
      _createTareasSheet(excel, dashboardData);
      _createActivitySheet(excel, dashboardData);

      // Guardar Excel usando una alternativa
      final List<int>? excelBytes = excel.save();
      if (excelBytes != null) {
        // SOLUCIÓN: Usar Share.shareXFiles directamente con bytes temporales
        await _shareExcelBytes(
          Uint8List.fromList(excelBytes),
          'dashboard_manazco_${DateTime.now().millisecondsSinceEpoch}.xlsx',
        );
      }
    } catch (e) {
      throw Exception('Error generando Excel: $e');
    }
  }

  // === MÉTODOS CORREGIDOS DE GUARDADO ===

  // NUEVO: Método alternativo para compartir Excel sin path_provider
  static Future<void> _shareExcelBytes(
    Uint8List excelBytes,
    String fileName,
  ) async {
    try {
      // Crear archivo temporal usando Platform.pathSeparator
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}${Platform.pathSeparator}$fileName');
      await file.writeAsBytes(excelBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Dashboard ManAzco');

      // Limpiar archivo temporal después de compartir
      Future.delayed(const Duration(seconds: 5), () {
        try {
          if (file.existsSync()) {
            file.deleteSync();
          }
        } catch (e) {
          // Ignorar errores de limpieza
        }
      });
    } catch (e) {
      // Si falla, usar Share.share con texto básico
      await Share.share(
        'No se pudo generar el archivo Excel. Datos del dashboard en texto.',
      );
    }
  }

  // === TODOS LOS MÉTODOS DE PDF SE MANTIENEN IGUAL ===
  static pw.Widget _buildPDFHeader() {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        color: PdfColors.blue,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Dashboard de Estadísticas - ManAzco',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Reporte generado el ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.white),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPDFExecutiveSummary(Map<String, dynamic> data) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Resumen Ejecutivo',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildPDFMetricCard(
                'Total Noticias',
                data['totalNoticias']?.toString() ?? '0',
              ),
              _buildPDFMetricCard(
                'Progreso Tareas',
                '${data['progresoTareas'] ?? 0}%',
              ),
              _buildPDFMetricCard(
                'Total Reportes',
                data['totalReportes']?.toString() ?? '0',
              ),
              _buildPDFMetricCard(
                'Tareas Activas',
                data['tareasActivas']?.toString() ?? '0',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPDFMetricCard(String title, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPDFNoticiasMetrics(Map<String, dynamic> data) {
    final noticias = data['noticias'] as List? ?? [];

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Métricas de Noticias',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Total de noticias: ${noticias.length}'),
          pw.Text('Reportes totales: ${data['totalReportes'] ?? 0}'),
          pw.Text('Comentarios totales: ${data['totalComentarios'] ?? 0}'),
          if (noticias.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text(
              'Últimas noticias:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            ...noticias
                .take(3)
                .map(
                  (noticia) => pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 8, top: 4),
                    child: pw.Text('• ${noticia['titulo'] ?? 'Sin título'}'),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildPDFTareasMetrics(Map<String, dynamic> data) {
    final tareas = data['tareas'] as List? ?? [];
    final completadas = tareas.where((t) => t['completado'] == true).length;
    final pendientes = tareas.length - completadas;

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Métricas de Tareas',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Total de tareas: ${tareas.length}'),
          pw.Text('Tareas completadas: $completadas'),
          pw.Text('Tareas pendientes: $pendientes'),
          pw.Text(
            'Progreso: ${tareas.isNotEmpty ? ((completadas / tareas.length) * 100).toInt() : 0}%',
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPDFActivitySection(Map<String, dynamic> data) {
    final activities = data['activities'] as List? ?? [];

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Actividad Reciente',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          if (activities.isEmpty)
            pw.Text('No hay actividad reciente')
          else
            ...activities
                .take(5)
                .map(
                  (activity) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text('• ${activity['title'] ?? 'Sin título'}'),
                  ),
                ),
        ],
      ),
    );
  }

  // === MÉTODOS PARA EXCEL (SE MANTIENEN IGUAL) ===

  static void _createDashboardSheet(Excel excel, Map<String, dynamic> data) {
    final sheet = excel['Dashboard'];

    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'ManAzco - Dashboard de Estadísticas',
    );
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue(
      'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    );

    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Métrica');
    sheet.cell(CellIndex.indexByString('B4')).value = TextCellValue('Valor');

    sheet.cell(CellIndex.indexByString('A5')).value = TextCellValue(
      'Total Noticias',
    );
    sheet.cell(CellIndex.indexByString('B5')).value = IntCellValue(
      data['totalNoticias'] ?? 0,
    );

    sheet.cell(CellIndex.indexByString('A6')).value = TextCellValue(
      'Progreso Tareas',
    );
    sheet.cell(CellIndex.indexByString('B6')).value = TextCellValue(
      '${data['progresoTareas'] ?? 0}%',
    );

    sheet.cell(CellIndex.indexByString('A7')).value = TextCellValue(
      'Total Reportes',
    );
    sheet.cell(CellIndex.indexByString('B7')).value = IntCellValue(
      data['totalReportes'] ?? 0,
    );

    sheet.cell(CellIndex.indexByString('A8')).value = TextCellValue(
      'Tareas Activas',
    );
    sheet.cell(CellIndex.indexByString('B8')).value = IntCellValue(
      data['tareasActivas'] ?? 0,
    );
  }

  static void _createNoticiasSheet(Excel excel, Map<String, dynamic> data) {
    final sheet = excel['Noticias'];
    final noticias = data['noticias'] as List? ?? [];

    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Título');
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Reportes');
    sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue(
      'Comentarios',
    );

    for (int i = 0; i < noticias.length; i++) {
      final noticia = noticias[i];
      sheet.cell(CellIndex.indexByString('A${i + 2}')).value = TextCellValue(
        noticia['titulo'] ?? '',
      );
      sheet.cell(CellIndex.indexByString('B${i + 2}')).value = IntCellValue(
        noticia['contadorReportes'] ?? 0,
      );
      sheet.cell(CellIndex.indexByString('C${i + 2}')).value = IntCellValue(
        noticia['contadorComentarios'] ?? 0,
      );
    }
  }

  static void _createTareasSheet(Excel excel, Map<String, dynamic> data) {
    final sheet = excel['Tareas'];
    final tareas = data['tareas'] as List? ?? [];

    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Título');
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Estado');
    sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue(
      'Descripción',
    );

    for (int i = 0; i < tareas.length; i++) {
      final tarea = tareas[i];
      sheet.cell(CellIndex.indexByString('A${i + 2}')).value = TextCellValue(
        tarea['titulo'] ?? '',
      );
      sheet.cell(CellIndex.indexByString('B${i + 2}')).value = TextCellValue(
        tarea['completado'] == true ? 'Completada' : 'Pendiente',
      );
      sheet.cell(CellIndex.indexByString('C${i + 2}')).value = TextCellValue(
        tarea['descripcion'] ?? '',
      );
    }
  }

  static void _createActivitySheet(Excel excel, Map<String, dynamic> data) {
    final sheet = excel['Actividad'];
    final activities = data['activities'] as List? ?? [];

    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'Actividad',
    );
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Tiempo');

    for (int i = 0; i < activities.length; i++) {
      final activity = activities[i];
      sheet.cell(CellIndex.indexByString('A${i + 2}')).value = TextCellValue(
        activity['title'] ?? '',
      );
      sheet.cell(CellIndex.indexByString('B${i + 2}')).value = TextCellValue(
        activity['time'] ?? '',
      );
    }
  }
}
