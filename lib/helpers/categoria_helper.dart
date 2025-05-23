import 'package:manazco/constants/constantes.dart';
import 'package:manazco/domain/categoria.dart';

class CategoriaHelper {
  static String obtenerNombreCategoria(
    String categoriaId,
    List<Categoria> categorias,
  ) {
    if (categoriaId.isEmpty ||
        categoriaId == CategoriaConstantes.defaultcategoriaId) {
      return CategoriaConstantes.defaultcategoriaId;
    }

    final categoria = categorias.firstWhere(
      (c) => c.id == categoriaId,
      orElse:
          () => const Categoria(
            id: '',
            nombre: CategoriaConstantes.defaultcategoriaId,
            descripcion: '',
            imagenUrl: '',
          ),
    );
    return categoria.nombre;
  }
}
