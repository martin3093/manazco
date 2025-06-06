import 'dart:async';
import 'package:manazco/api/service/base_service.dart';
import 'package:manazco/constants/constantes.dart';
import 'package:manazco/domain/reporte.dart';

class ReporteService extends BaseService {
  /// Envía un reporte
  Future<void> enviarReporte(Reporte reporte) async {
    await post(
      ApiConstantes.reportesEndpoint,
      data: reporte.toMap(),
      errorMessage: ReporteConstantes.errorCrear,
    );
  }

  /// Obtiene todos los reportes de una noticia específica
  Future<List<Reporte>> obtenerReportes(noticiaId) async {
    final List<dynamic> reportesJson = await get<List<dynamic>>(
      '${ApiConstantes.reportesEndpoint}?noticiaId=$noticiaId',
      errorMessage: ReporteConstantes.errorObtenerReportes,
    );
    return reportesJson
        .map<Reporte>(
          (json) => ReporteMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Elimina todos los reportes asociados a una noticia
  Future<void> eliminarReportesPorNoticia(String noticiaId) async {
    // 1. Primero obtenemos todos los reportes de la noticia
    final reportes = await obtenerReportes(noticiaId);

    // 2. Eliminamos cada reporte individualmente
    for (final reporte in reportes) {
      if (reporte.id != null) {
        await delete(
          '${ApiConstantes.reportesEndpoint}/${reporte.id}',
          errorMessage: ReporteConstantes.errorEliminarReportes,
        );
      }
    }
  }
}
