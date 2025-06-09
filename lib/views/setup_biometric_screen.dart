// import 'package:flutter/material.dart';
// import 'package:manazco/api/service/biometric_service.dart';

// class SetupBiometricScreen extends StatefulWidget {
//   final String userEmail;
//   final String userName;

//   const SetupBiometricScreen({
//     super.key,
//     required this.userEmail,
//     required this.userName,
//   });

//   @override
//   State<SetupBiometricScreen> createState() => _SetupBiometricScreenState();
// }

// class _SetupBiometricScreenState extends State<SetupBiometricScreen> {
//   bool _configurando = false;
//   String _mensaje = '';

//   Future<void> _configurarHuella() async {
//     setState(() {
//       _configurando = true;
//       _mensaje = 'Configurando...';
//     });

//     try {
//       // Verificar que el dispositivo puede usar huella
//       final puedeUsar = await BiometricService.puedeUsarHuella();

//       if (!puedeUsar) {
//         setState(() {
//           _mensaje = '❌ Tu dispositivo no soporta huella digital';
//           _configurando = false;
//         });
//         return;
//       }

//       // Guardar usuario con huella
//       final guardado = await BiometricService.guardarUsuarioConHuella(
//         email: widget.userEmail,
//         nombre: widget.userName,
//       );

//       if (guardado) {
//         setState(() {
//           _mensaje = '✅ ¡Huella configurada correctamente!';
//           _configurando = false;
//         });

//         // Mostrar diálogo de éxito
//         _mostrarDialogoExito();
//       } else {
//         setState(() {
//           _mensaje = '❌ No se pudo configurar la huella';
//           _configurando = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _mensaje = '🚨 Error: $e';
//         _configurando = false;
//       });
//     }
//   }

//   void _mostrarDialogoExito() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             title: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green),
//                 SizedBox(width: 8),
//                 Text('¡Éxito!'),
//               ],
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.fingerprint, size: 64, color: Colors.blue),
//                 SizedBox(height: 16),
//                 Text(
//                   'Tu huella ha sido configurada correctamente.',
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Ahora podrás usar tu huella para iniciar sesión rápidamente.',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Cerrar diálogo
//                   Navigator.pop(context, true); // Volver con resultado exitoso
//                 },
//                 child: Text('Entendido'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Configurar Huella'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Información del usuario
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Colors.blue,
//                       child: Text(
//                         widget.userName.isNotEmpty
//                             ? widget.userName[0].toUpperCase()
//                             : 'U',
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       widget.userName,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       widget.userEmail,
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: 40),

//             // Ícono de huella
//             Icon(
//               Icons.fingerprint,
//               size: 100,
//               color: _configurando ? Colors.orange : Colors.blue,
//             ),

//             SizedBox(height: 20),

//             // Título
//             Text(
//               'Configurar Acceso con Huella',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),

//             SizedBox(height: 16),

//             // Descripción
//             Text(
//               'Configura tu huella digital para acceder más rápido a la aplicación.',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               textAlign: TextAlign.center,
//             ),

//             SizedBox(height: 20),

//             // Mensaje de estado
//             if (_mensaje.isNotEmpty)
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   _mensaje,
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             SizedBox(height: 40),

//             // Botones
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context, false);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: Text('Ahora no'),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton.icon(
//                     onPressed: _configurando ? null : _configurarHuella,
//                     icon:
//                         _configurando
//                             ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                             : Icon(Icons.fingerprint),
//                     label: Text(
//                       _configurando ? 'Configurando...' : 'Configurar Huella',
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 30),

//             // Instrucciones
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.blue[200]!),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.info, color: Colors.blue[700]),
//                   SizedBox(height: 8),
//                   Text(
//                     'INSTRUCCIONES',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[700],
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '1. Al presionar "Configurar", aparecerá el sensor de huella\n'
//                     '2. Coloca tu dedo en el sensor\n'
//                     '3. Una vez confirmada, podrás usar huella para el login',
//                     style: TextStyle(fontSize: 12),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
