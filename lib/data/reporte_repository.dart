import 'package:manazco/api/service/reporte_service.dart';
import 'package:manazco/data/base_repository.dart';
import 'package:manazco/domain/reporte.dart';
import 'package:manazco/exceptions/api_exception.dart';

class ReporteRepository extends BaseRepository {
  final ReporteService _reporteService = ReporteService();

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      // Crear un nuevo reporte

      logOperationStart('obtener', 'reportes');

      final reportes = await _reporteService.getReportes();

      logOperationSuccess('obtenidos', 'reportes');
      return reportes;
    } on ApiException catch (e) {
      throw Exception('Error al obtener reportes: ${e.message}');
    } catch (e) {
      return handleError(e, 'al obtener', 'reportes');
    }
  }

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      return await _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      );
    } on ApiException catch (e) {
      throw Exception('Error al crear reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error al crear reporte: ${e.toString()}');
    }
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      checkIdNotEmpty(noticiaId, 'noticia');
      logOperationStart('obtener reportes para noticia', 'reportes', noticiaId);

      final reportes = await _reporteService.getReportesPorNoticia(noticiaId);

      logOperationSuccess('obtenidos para noticia', 'reportes', noticiaId);
      return reportes;
    } on ApiException catch (e) {
      throw Exception('Error al obtener reportes por noticia: ${e.message}');
    } catch (e) {
      return handleError(e, 'al obtener reportes para noticia', 'reportes');
    }
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) async {
    try {
      checkIdNotEmpty(reporteId, 'reporte');
      logOperationStart('eliminar', 'reporte', reporteId);
      await _reporteService.eliminarReporte(reporteId);
      logOperationSuccess('eliminado', 'reporte', reporteId);
    } on ApiException catch (e) {
      throw Exception('Error al eliminar reporte: ${e.message}');
    } catch (e) {
      handleError(e, 'al eliminar', 'reporte');
      rethrow;
    }
  }
}
