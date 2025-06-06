import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:manazco/bloc/auth/auth_bloc.dart';
import 'package:manazco/bloc/comentario/comentario_bloc.dart';
import 'package:manazco/bloc/reporte/reporte_bloc.dart';
import 'package:manazco/bloc/tarea/tarea_bloc.dart';
import 'package:manazco/bloc/theme/theme_cubit.dart';
import 'package:manazco/bloc/theme/theme_state.dart';
import 'package:manazco/di/locator.dart';
import 'package:manazco/bloc/contador/contador_bloc.dart';
import 'package:manazco/bloc/connectivity/connectivity_bloc.dart';
import 'package:manazco/components/connectivity_wrapper.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/helpers/shared_preferences_service.dart';
import 'package:manazco/theme/app_themes.dart';

import 'package:manazco/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';
import 'package:manazco/bloc/noticia/noticia_bloc.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Cargar variables de entorno
    await dotenv.load(fileName: ".env");

    // Inicializar servicios y dependencias
    await initLocator();
    await SharedPreferencesService().init();

    // Limpiar datos de sesión anterior
    final secureStorage = di<SecureStorageService>();
    await secureStorage.clearJwt();
    await secureStorage.clearUserEmail();

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error durante la inicialización: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error al iniciar la aplicación: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContadorBloc>(create: (context) => ContadorBloc()),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider(create: (context) => ComentarioBloc()),
        BlocProvider(create: (context) => ReporteBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        // Agregamos NoticiaBloc como un provider global para mantener el estado entre navegaciones
        BlocProvider<NoticiaBloc>(create: (context) => NoticiaBloc()),
        BlocProvider<TareaBloc>(
          create: (context) => TareaBloc(),
          lazy: false, // Esto asegura que el bloc se cree inmediatamente
        ),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Flutter Demo',
            // theme: AppTheme.bootcampTheme,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeState.themeMode,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              // Envolvemos con nuestro ConnectivityWrapper
              return ConnectivityWrapper(
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: LoginScreen(), // Pantalla inicial
            // home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
