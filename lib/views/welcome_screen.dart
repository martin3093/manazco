import 'package:flutter/material.dart';
import 'package:manazco/components/side_menu.dart';
import 'package:manazco/components/welcome_animation.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/views/biometric_auth_screen.dart';
import 'package:manazco/views/login_screen.dart';
import 'package:manazco/views/dashboard_screen.dart';
import 'package:manazco/views/tarea_screen.dart';
import 'package:manazco/views/noticia_screen.dart';
import 'package:manazco/views/quote_screen.dart';
import 'package:manazco/views/profile_screen.dart';
import 'package:manazco/views/contador_screen.dart';
import 'package:manazco/views/mi_app_screen.dart';
import 'package:manazco/views/enhanced_login_screen.dart';
import 'package:watch_it/watch_it.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  String _userEmail = '';
  bool _showAnimation = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _verificarAutenticacionYCargarEmail();

    // Configurar animación de fade out
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Ocultar la animación después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _fadeController.forward().then((_) {
          if (mounted) {
            setState(() {
              _showAnimation = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _verificarAutenticacionYCargarEmail() async {
    final SecureStorageService secureStorage = di<SecureStorageService>();
    final token = await secureStorage.getJwt();

    // Check if user is logged in
    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
      return;
    }

    // Check if biometric verification is complete
    final biometricVerified = await secureStorage.getBiometricVerified();
    if (!biometricVerified) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BiometricAuthScreen()),
        );
      }
      return;
    }

    // Load user email if everything is verified
    final email = await secureStorage.getUserEmail() ?? 'Usuario';
    if (mounted) {
      setState(() {
        _userEmail = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: Stack(
        children: [
          // Contenido principal con iconos de acceso directo
          SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saludo personalizado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(
                          context,
                        ).primaryColor.withAlpha((0.8 * 255).round()),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, ${_extractUsernameFromEmail(_userEmail)}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bienvenido a ManAzco',
                        style: TextStyle(
                          color: Colors.white.withAlpha((0.9 * 255).round()),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Sección de accesos rápidos
                Text(
                  'Accesos Rápidos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Grid de iconos principales
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.1,
                  children: [
                    _buildQuickAccessCard(
                      context: context,
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      color: Colors.blue,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ),
                          ),
                    ),
                    _buildQuickAccessCard(
                      context: context,
                      icon: Icons.task,
                      title: 'Tareas',
                      color: Colors.green,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TareaScreen(),
                            ),
                          ),
                    ),
                    _buildQuickAccessCard(
                      context: context,
                      icon: Icons.newspaper,
                      title: 'Noticias',
                      color: Colors.orange,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NoticiaScreen(),
                            ),
                          ),
                    ),
                    _buildQuickAccessCard(
                      context: context,
                      icon: Icons.bar_chart,
                      title: 'Cotizaciones',
                      color: Colors.purple,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QuoteScreen(),
                            ),
                          ),
                    ),
                    _buildQuickAccessCard(
                      context: context,
                      icon: Icons.person,
                      title: 'Mi Perfil',
                      color: Colors.teal,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          ),
                    ),
                    _buildQuickAccessCard(
                      context: context,
                      icon: Icons.apps,
                      title: 'Más Apps',
                      color: Colors.indigo,
                      onTap: () => _showMoreAppsDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Sección de funciones especiales
                Text(
                  'Funciones Especiales',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Cards horizontales para funciones especiales
                _buildFeatureCard(
                  context: context,
                  icon: Icons.fingerprint,
                  title: 'Autenticación Biométrica',
                  subtitle: 'Accede con tu huella digital',
                  color: Colors.deepPurple,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnhancedLoginScreen(),
                        ),
                      ),
                ),

                const SizedBox(height: 8),

                _buildFeatureCard(
                  context: context,
                  icon: Icons.security,
                  title: 'Configuración Avanzada',
                  subtitle: 'Personaliza tu experiencia',
                  color: Colors.blueGrey,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),

          // Pantalla flotante de animación
          if (_showAnimation)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(child: WelcomeAnimation(username: _userEmail)),
              ),
            ),
        ],
      ),
    );
  }

  // Métodos auxiliares
  String _extractUsernameFromEmail(String email) {
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return email;
  }

  Widget _buildQuickAccessCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withAlpha((0.1 * 255).round()),
                color.withAlpha((0.05 * 255).round()),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.2 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  // color: color.withAlpha((0.8 * 255).round()),
                  color: color.withAlpha((0.8 * 255).round()),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: color.withAlpha((0.1 * 255).round()),
                  color: color.withAlpha((0.1 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Más Aplicaciones'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.numbers, color: Colors.blue),
                  title: const Text('Contador'),
                  subtitle: const Text('Aplicación de contador simple'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const ContadorScreen(title: 'Contador'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.apps, color: Colors.green),
                  title: const Text('Mi App'),
                  subtitle: const Text('Aplicación personalizada'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MiAppScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
