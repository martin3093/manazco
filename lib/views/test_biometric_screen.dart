import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Agregar para PlatformException
import 'package:local_auth/local_auth.dart';

class TestBiometricScreen extends StatefulWidget {
  const TestBiometricScreen({super.key});

  @override
  State<TestBiometricScreen> createState() => _TestBiometricScreenState();
}

class _TestBiometricScreenState extends State<TestBiometricScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _resultado = 'Presiona el botón para probar';
  bool _cargando = false;

  // ✅ Función mejorada con mejor manejo de errores
  Future<void> _probarHuella() async {
    setState(() {
      _cargando = true;
      _resultado = 'Probando...';
    });

    try {
      // 1. Verificar si el dispositivo tiene biometría
      final bool estaDisponible = await auth.canCheckBiometrics;
      final bool esCompatible = await auth.isDeviceSupported();

      if (!estaDisponible || !esCompatible) {
        setState(() {
          _resultado = '❌ Tu dispositivo no tiene biometría disponible';
          _cargando = false;
        });
        return;
      }

      // 2. Verificar tipos de biometría disponibles
      final List<BiometricType> tiposDisponibles =
          await auth.getAvailableBiometrics();

      if (tiposDisponibles.isEmpty) {
        setState(() {
          _resultado = '❌ No hay biometría configurada en el dispositivo';
          _cargando = false;
        });
        return;
      }

      // 3. Intentar autenticar
      final bool resultado = await auth.authenticate(
        localizedReason: 'Confirma tu identidad para continuar',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // ✅ Mantener diálogo hasta completar
        ),
      );

      // 4. Mostrar resultado
      setState(() {
        if (resultado) {
          _resultado = '✅ ¡Autenticación exitosa!';
        } else {
          _resultado = '❌ Autenticación fallida';
        }
        _cargando = false;
      });
    } on PlatformException catch (e) {
      // ✅ Manejo específico de errores de plataforma
      String errorMessage;

      switch (e.code) {
        case 'NotAvailable':
          errorMessage = '❌ Biometría no disponible';
          break;
        case 'NotEnrolled':
          errorMessage = '❌ No hay biometría registrada en el dispositivo';
          break;
        case 'no_fragment_activity':
          errorMessage = '🔧 Error de configuración - Reinicia la app';
          break;
        case 'LockedOut':
          errorMessage = '🔒 Biometría bloqueada temporalmente';
          break;
        case 'PermanentlyLockedOut':
          errorMessage = '🔒 Biometría bloqueada permanentemente';
          break;
        case 'UserCancel':
          errorMessage = '❌ Autenticación cancelada';
          break;
        default:
          errorMessage = '🚨 Error: ${e.code} - ${e.message}';
      }

      setState(() {
        _resultado = errorMessage;
        _cargando = false;
      });

      print('PlatformException: ${e.code} - ${e.message}');
    } catch (e) {
      setState(() {
        _resultado = '🚨 Error inesperado: $e';
        _cargando = false;
      });
    }
  }

  // ✅ Función para verificar configuración
  Future<void> _verificarConfiguracion() async {
    try {
      final bool esCompatible = await auth.isDeviceSupported();
      final bool estaDisponible = await auth.canCheckBiometrics;
      final List<BiometricType> tipos = await auth.getAvailableBiometrics();

      String info = 'ℹ️ Información del dispositivo:\n';
      info += '• Compatible: ${esCompatible ? "Sí" : "No"}\n';
      info += '• Disponible: ${estaDisponible ? "Sí" : "No"}\n';
      info += '• Tipos: ${tipos.map((t) => t.name).join(", ")}';

      setState(() {
        _resultado = info;
      });
    } catch (e) {
      setState(() {
        _resultado = '🚨 Error verificando: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Probar Huella Digital'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // ✅ Agregar botón de información
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _verificarConfiguracion,
            tooltip: 'Verificar configuración',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono grande
              Icon(
                Icons.fingerprint,
                size: 120,
                color: _cargando ? Colors.orange : Colors.blue,
              ),

              const SizedBox(height: 30),

              // Título
              Text(
                'Prueba de Huella Digital',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Resultado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  _resultado,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Botones
              Row(
                children: [
                  // Botón para probar
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _cargando ? null : _probarHuella,
                      icon:
                          _cargando
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.fingerprint),
                      label: Text(
                        _cargando ? 'Probando...' : 'Probar Huella',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Botón de información
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: _verificarConfiguracion,
                      icon: const Icon(Icons.info),
                      label: const Text('Info'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Instrucciones actualizadas
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow[300]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info, color: Colors.orange[700], size: 30),
                    const SizedBox(height: 8),
                    Text(
                      'SOLUCIÓN AL ERROR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Si sale error "no_fragment_activity", reinicia la app completamente\n'
                      '• Solo funciona en dispositivo físico\n'
                      '• Debes tener huella configurada\n'
                      '• Presiona "Info" para verificar configuración',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
