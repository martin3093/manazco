import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/auth/auth_bloc.dart';
import 'package:manazco/bloc/auth/auth_event.dart';
import 'package:manazco/bloc/noticia/noticia_bloc.dart';
import 'package:manazco/bloc/noticia/noticia_event.dart';
import 'package:manazco/data/preferencia_repository.dart';
import 'package:manazco/theme/theme.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:get_it/get_it.dart';

/// Helper para gestionar diferentes tipos de diálogos en la aplicación
class DialogHelper {
  /// Muestra un diálogo de confirmación genérico
  static Future<bool?> mostrarConfirmacion({
    required BuildContext context,
    required String titulo,
    required String mensaje,
    String textoCancelar = 'Cancelar',
    String textoConfirmar = 'Confirmar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: AppTheme.modalSecondaryButtonStyle(),
              child: Text(textoCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: AppTheme.modalActionButtonStyle(),
              child: Text(textoConfirmar),
            ),
          ],
        );
      },
    );
  }

  /// Muestra un diálogo específico para cerrar sesión
  static void mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              style:
                  AppTheme.modalSecondaryButtonStyle(), // Usar estilo del tema
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Cerramos primero el diálogo
                Navigator.of(context).pop();

                // Obtener instancia del PreferenciaRepository para limpiar la caché
                final preferenciasRepo =
                    GetIt.instance<PreferenciaRepository>();

                // Limpiar caché de preferencias ANTES del logout y redirección
                preferenciasRepo.invalidarCache();
                // Obtener referencia al NoticiaBloc para reiniciarlo
                if (context.mounted) {
                  try {
                    final noticiaBloc = BlocProvider.of<NoticiaBloc>(
                      context,
                      listen: false,
                    );
                    // Reiniciar el NoticiaBloc completamente en lugar de hacer fetch
                    noticiaBloc.add(ResetNoticiaEvent());
                  } catch (e) {
                    // Ignorar si NoticiaBloc no está disponible
                  }
                }

                // Usar el BLoC para manejar el cierre de sesión
                if (context.mounted) {
                  BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
                }

                // Redireccionar a la pantalla de login, eliminando todas las pantallas del stack
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false, // Elimina todas las rutas previas
                  );
                }
              },
              style: AppTheme.modalActionButtonStyle(), // Usar estilo del tema
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}
