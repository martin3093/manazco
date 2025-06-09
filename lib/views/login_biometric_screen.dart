// import 'package:flutter/material.dart';
// import 'package:manazco/api/service/biometric_service.dart';
// import 'package:manazco/views/setup_biometric_screen.dart';

// class LoginBiometricScreen extends StatefulWidget {
//   const LoginBiometricScreen({super.key});

//   @override
//   State<LoginBiometricScreen> createState() => _LoginBiometricScreenState();
// }

// class _LoginBiometricScreenState extends State<LoginBiometricScreen> {
//   bool _cargando = true;
//   bool _tieneUsuarioGuardado = false;
//   Map<String, String>? _usuarioGuardado;
//   String _mensaje = 'Verificando...';

//   @override
//   void initState() {
//     super.initState();
//     _verificarUsuarioGuardado();
//   }

//   Future<void> _verificarUsuarioGuardado() async {
//     try {
//       final tieneUsuario = await BiometricService.tieneUsuarioGuardado();
//       final usuario = await BiometricService.obtenerUsuarioGuardado();

//       setState(() {
//         _tieneUsuarioGuardado = tieneUsuario;
//         _usuarioGuardado = usuario;
//         _cargando = false;

//         if (tieneUsuario && usuario != null) {
//           _mensaje = 'Usuario encontrado: ${usuario['nombre']}';
//         } else {
//           _mensaje = 'No hay usuario configurado con huella';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _cargando = false;
//         _mensaje = 'Error verificando usuario: $e';
//       });
//     }
//   }

//   Future<void> _loginConHuella() async {
//     setState(() {
//       _mensaje = 'Autenticando...';
//     });

//     try {
//       final usuario = await BiometricService.loginConHuella();

//       if (usuario != null) {
//         setState(() {
//           _mensaje = '✅ ¡Login exitoso! Bienvenido ${usuario['nombre']}';
//         });

//         // Simular navegación a pantalla principal
//         await Future.delayed(Duration(seconds: 1));

//         // Aquí navegarías a tu pantalla principal
//         _mostrarDialogoExito(usuario);
//       } else {
//         setState(() {
//           _mensaje = '❌ Autenticación fallida';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _mensaje = '🚨 Error: $e';
//       });
//     }
//   }

//   void _mostrarDialogoExito(Map<String, String> usuario) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green),
//                 SizedBox(width: 8),
//                 Text('¡Bienvenido!'),
//               ],
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.green,
//                   child: Text(
//                     usuario['nombre']![0].toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Login exitoso como:'),
//                 Text(
//                   usuario['nombre']!,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   usuario['email']!,
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Aquí navegarías a tu pantalla principal
//                   // Navigator.pushReplacementNamed(context, '/home');
//                 },
//                 child: Text('Continuar'),
//               ),
//             ],
//           ),
//     );
//   }

//   Future<void> _configurarNuevoUsuario() async {
//     // Simular datos de usuario (en tu app real vendrían del login normal)
//     final result = await Navigator.push<bool>(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => SetupBiometricScreen(
//               userEmail: 'usuario@ejemplo.com',
//               userName: 'Usuario Ejemplo',
//             ),
//       ),
//     );

//     if (result == true) {
//       // Recargar pantalla
//       _verificarUsuarioGuardado();
//     }
//   }

//   Future<void> _eliminarUsuario() async {
//     final confirmado = await showDialog<bool>(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text('Eliminar Usuario'),
//             content: const Text(
//               '¿Estás seguro de eliminar la configuración de huella?\n'
//               'Tendrás que configurarla nuevamente.',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: Text('Cancelar'),
//               ),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 child: Text('Eliminar'),
//               ),
//             ],
//           ),
//     );

//     if (confirmado == true) {
//       final eliminado = await BiometricService.eliminarUsuarioGuardado();
//       if (eliminado) {
//         _verificarUsuarioGuardado();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login con Huella'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           if (_tieneUsuarioGuardado)
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: _eliminarUsuario,
//               tooltip: 'Eliminar configuración',
//             ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_cargando) ...[
//               CircularProgressIndicator(),
//               SizedBox(height: 20),
//               Text('Verificando configuración...'),
//             ] else ...[
//               // Usuario guardado
//               if (_tieneUsuarioGuardado && _usuarioGuardado != null) ...[
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.blue,
//                           child: Text(
//                             _usuarioGuardado!['nombre']![0].toUpperCase(),
//                             style: TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           _usuarioGuardado!['nombre']!,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           _usuarioGuardado!['email']!,
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 40),

//                 Icon(Icons.fingerprint, size: 100, color: Colors.blue),

//                 SizedBox(height: 20),

//                 Text(
//                   'Usa tu Huella para Acceder',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),

//                 SizedBox(height: 40),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: _loginConHuella,
//                     icon: Icon(Icons.fingerprint),
//                     label: Text(
//                       'Iniciar Sesión con Huella',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                     ),
//                   ),
//                 ),
//               ] else ...[
//                 // No hay usuario guardado
//                 Icon(Icons.fingerprint_outlined, size: 100, color: Colors.grey),

//                 SizedBox(height: 20),

//                 Text(
//                   'No hay Usuario Configurado',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),

//                 SizedBox(height: 16),

//                 Text(
//                   'Configura tu huella digital para acceder rápidamente.',
//                   style: TextStyle(color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),

//                 SizedBox(height: 40),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: _configurarNuevoUsuario,
//                     icon: Icon(Icons.add),
//                     label: const Text(
//                       'Configurar Usuario',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                     ),
//                   ),
//                 ),
//               ],

//               SizedBox(height: 20),

//               // Mensaje de estado
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   _mensaje,
//                   style: TextStyle(fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
