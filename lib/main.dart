import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:manazco/bloc/auth/auth_bloc.dart';
import 'package:manazco/bloc/comentario/comentario_bloc.dart';
import 'package:manazco/bloc/reporte/reporte_bloc.dart';
import 'package:manazco/di/locator.dart';
import 'package:manazco/bloc/contador/contador_bloc.dart';
import 'package:manazco/bloc/connectivity/connectivity_bloc.dart';
import 'package:manazco/components/connectivity_wrapper.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:watch_it/watch_it.dart';
import 'package:manazco/bloc/noticia/noticia_bloc.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await initLocator(); // Carga el archivo .env

  // Eliminar cualquier token guardado para forzar el inicio de sesión
  final secureStorage = di<SecureStorageService>();
  await secureStorage.clearJwt();
  await secureStorage.clearUserEmail();

  runApp(const MyApp());
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        ),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          // Envolvemos con nuestro ConnectivityWrapper
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
        home: LoginScreen(), // Pantalla inicial
      ),
    );
  }
}
