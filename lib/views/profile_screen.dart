// lib/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/components/side_menu.dart';
import 'package:manazco/widgets/theme_switcher.dart';
import 'package:manazco/bloc/auth/auth_bloc.dart';
import 'package:manazco/bloc/auth/auth_state.dart';
import 'package:manazco/bloc/auth/auth_event.dart';
import 'package:manazco/bloc/tarea/tarea_bloc.dart';
import 'package:manazco/bloc/tarea/tarea_state.dart';
import 'package:manazco/bloc/tarea/tarea_event.dart';
import 'package:manazco/helpers/secure_storage_service.dart';
import 'package:manazco/helpers/dialog_helper.dart';
import 'package:watch_it/watch_it.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SecureStorageService _secureStorage = di<SecureStorageService>();
  String? _userEmail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Cargar estadísticas de tareas reales
    context.read<TareaBloc>().add(LoadTareasEvent());
  }

  Future<void> _loadUserData() async {
    try {
      final email = await _secureStorage.getUserEmail();
      if (mounted) {
        setState(() {
          _userEmail = email;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProfileDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _refreshUserData();
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Usuario no autenticado...'),
                ],
              ),
            );
          }

          if (_isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando datos del usuario...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshUserData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Avatar y nombre - CON DATOS REALES
                  _buildProfileHeaderReal(),

                  const SizedBox(height: 24),

                  // Información personal - CON DATOS REALES
                  _buildPersonalInfoReal(),

                  const SizedBox(height: 16),

                  // Configuraciones
                  _buildSettings(),

                  const SizedBox(height: 16),

                  // Estadísticas REALES de tareas
                  _buildStatisticsReal(),

                  const SizedBox(height: 16),

                  // Configuración de temas
                  _buildThemeSettings(),

                  const SizedBox(height: 16),

                  // Notificaciones
                  _buildNotificationSettings(),

                  const SizedBox(height: 16),

                  // Logros basados en estadísticas reales
                  _buildAchievementsReal(),

                  const SizedBox(height: 16),

                  // Historial de actividad real
                  _buildActivityHistoryReal(),

                  const SizedBox(height: 16),

                  // Configuración de cuenta
                  _buildAccountSettings(context),

                  const SizedBox(height: 16),

                  // Soporte y ayuda
                  _buildSupportSection(),

                  const SizedBox(height: 16),

                  // Información de la app
                  _buildAppInfo(),

                  const SizedBox(height: 24),

                  // Botón de cerrar sesión REAL
                  _buildLogoutButtonReal(context),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeaderReal() {
    final userEmail = _userEmail ?? 'Usuario';
    final username = _extractUsernameFromEmail(userEmail);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar circular con iniciales reales
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    _getInitials(username),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Función de cambiar foto en desarrollo',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nombre y email - DATOS REALES
            Text(
              username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            // Estado basado en JWT
            FutureBuilder<String?>(
              future: _secureStorage.getJwt(),
              builder: (context, snapshot) {
                final hasToken = snapshot.hasData && snapshot.data!.isNotEmpty;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: hasToken ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasToken ? Icons.verified_user : Icons.warning,
                        size: 16,
                        color: hasToken ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasToken ? 'Usuario Autenticado' : 'Sesión Expirada',
                        style: TextStyle(
                          color: hasToken ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoReal() {
    final userEmail = _userEmail ?? 'No disponible';
    final username = _extractUsernameFromEmail(userEmail);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildInfoRow(Icons.person, 'Usuario', username),
            _buildInfoRow(Icons.email, 'Email', userEmail),
            _buildInfoRow(Icons.phone, 'Teléfono', 'No configurado'),
            _buildInfoRow(Icons.location_on, 'Ubicación', 'No especificada'),
            _buildInfoRow(Icons.work, 'Rol', 'Usuario Estándar'),

            // Tiempo como miembro basado en datos reales
            FutureBuilder<String?>(
              future: _secureStorage.getJwt(),
              builder: (context, snapshot) {
                return _buildInfoRow(
                  Icons.calendar_today,
                  'Estado de sesión',
                  snapshot.hasData && snapshot.data!.isNotEmpty
                      ? 'Sesión activa'
                      : 'Sin sesión',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsReal() {
    return BlocBuilder<TareaBloc, TareaState>(
      builder: (context, tareaState) {
        // Datos reales de las tareas
        int totalTareas = 0;
        int tareasCompletadas = 0;
        int diasActivo = 0;
        String rachaActual = '0 días';

        if (tareaState is TareaLoaded) {
          totalTareas = tareaState.tareas.length;
          tareasCompletadas =
              tareaState.tareas.where((t) => t.completado).length;

          // Calcular días activo basado en tareas
          if (tareaState.tareas.isNotEmpty) {
            final fechas =
                tareaState.tareas
                    .map((t) => DateTime.tryParse((t.fecha ?? '').toString()))
                    .where((f) => f != null)
                    .map((f) => f!)
                    .toList();

            if (fechas.isNotEmpty) {
              fechas.sort();
              diasActivo = DateTime.now().difference(fechas.first).inDays;
            }
          }

          // Calcular racha actual (simplificada)
          rachaActual =
              tareasCompletadas > 0
                  ? '${(tareasCompletadas / 7).ceil()} días'
                  : '0 días';
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estadísticas Reales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (tareaState is TareaLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                if (tareaState is TareaLoading) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else if (tareaState is TareaError) ...[
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(height: 8),
                        Text('Error: ${tareaState.error.message}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TareaBloc>().add(LoadTareasEvent());
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Tareas Completadas',
                          tareasCompletadas.toString(),
                          Icons.task_alt,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'Total Tareas',
                          totalTareas.toString(),
                          Icons.list,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Días Activo',
                          diasActivo.toString(),
                          Icons.calendar_today,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatCard(
                          'Progreso',
                          totalTareas > 0
                              ? '${((tareasCompletadas / totalTareas) * 100).toInt()}%'
                              : '0%',
                          Icons.trending_up,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementsReal() {
    return BlocBuilder<TareaBloc, TareaState>(
      builder: (context, tareaState) {
        int tareasCompletadas = 0;
        bool primeraTarea = false;
        bool racha7Dias = false;
        bool tareas50 = false;

        if (tareaState is TareaLoaded) {
          tareasCompletadas =
              tareaState.tareas.where((t) => t.completado).length;
          primeraTarea = tareasCompletadas >= 1;
          racha7Dias = tareasCompletadas >= 7;
          tareas50 = tareasCompletadas >= 50;
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Logros Reales',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildAchievementBadge(
                      'Primera Tarea',
                      Icons.star,
                      Colors.amber,
                      primeraTarea,
                    ),
                    _buildAchievementBadge(
                      '7+ Tareas',
                      Icons.local_fire_department,
                      Colors.orange,
                      racha7Dias,
                    ),
                    _buildAchievementBadge(
                      '50 Tareas',
                      Icons.task_alt,
                      Colors.green,
                      tareas50,
                    ),
                    _buildAchievementBadge(
                      'Usuario Activo',
                      Icons.emoji_events,
                      Colors.purple,
                      tareasCompletadas > 0,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Has completado $tareasCompletadas tareas',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityHistoryReal() {
    return BlocBuilder<TareaBloc, TareaState>(
      builder: (context, tareaState) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Actividad Reciente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navegar a historial completo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Navegación a historial completo en desarrollo',
                            ),
                          ),
                        );
                      },
                      child: const Text('Ver todo'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (tareaState is TareaLoaded &&
                    tareaState.tareas.isNotEmpty) ...[
                  // Mostrar últimas tareas completadas
                  ...tareaState.tareas
                      .where((t) => t.completado)
                      .take(3)
                      .map(
                        (tarea) => _buildActivityItem(
                          Icons.task_alt,
                          'Completaste la tarea "${tarea.titulo}"',
                          'Recientemente',
                          Colors.green,
                        ),
                      ),

                  // Actividad de login
                  _buildActivityItem(
                    Icons.login,
                    'Iniciaste sesión como ${_extractUsernameFromEmail(_userEmail ?? 'Usuario')}',
                    'Hoy',
                    Colors.blue,
                  ),
                ] else ...[
                  _buildActivityItem(
                    Icons.login,
                    'Iniciaste sesión',
                    'Hoy',
                    Colors.blue,
                  ),
                  _buildActivityItem(
                    Icons.person_add,
                    'Te uniste a la aplicación',
                    'Recientemente',
                    Colors.purple,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButtonReal(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          DialogHelper.mostrarDialogoCerrarSesion(context);
        },
        icon: const Icon(Icons.logout),
        label: const Text('Cerrar Sesión'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
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

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final words = name.split(' ');
    if (words.length >= 2) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Future<void> _refreshUserData() async {
    setState(() {
      _isLoading = true;
    });

    await _loadUserData();
    if (mounted) {
      context.read<TareaBloc>().add(LoadTareasEvent());
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Editar Perfil'),
            content: const Text(
              'La función de editar perfil estará disponible en una próxima actualización.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
    );
  }

  // Métodos que se mantienen igual
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
    String title,
    IconData icon,
    Color color,
    bool achieved,
  ) {
    return Container(
      width: 80,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: achieved ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: achieved ? color : Colors.grey, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: achieved ? color : Colors.grey, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: achieved ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String activity,
    String time,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuraciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Perfil'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showEditProfileDialog();
              },
            ),

            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Cambiar Contraseña'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacidad'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Idioma'),
              subtitle: const Text('Español'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apariencia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const ThemeSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text('Notificaciones Push'),
              subtitle: const Text('Recibir notificaciones en el dispositivo'),
              value: true,
              onChanged: (bool value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            SwitchListTile(
              title: const Text('Recordatorios de Tareas'),
              subtitle: const Text('Recordar tareas pendientes'),
              value: true,
              onChanged: (bool value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            SwitchListTile(
              title: const Text('Notificaciones por Email'),
              subtitle: const Text('Recibir actualizaciones por correo'),
              value: false,
              onChanged: (bool value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cuenta y Seguridad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Copia de Seguridad'),
              subtitle: const Text('Última copia: No disponible'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Exportar Datos'),
              subtitle: const Text('Descargar información personal'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Eliminar Cuenta'),
              subtitle: const Text('Eliminar permanentemente la cuenta'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Soporte y Ayuda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Centro de Ayuda'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Enviar Comentarios'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Reportar Problema'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Contactar Soporte'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información de la App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildInfoRow(Icons.info, 'Versión', '1.0.0'),
            _buildInfoRow(Icons.update, 'Última actualización', '15 Ene 2024'),
            _buildInfoRow(Icons.code, 'Desarrollado por', 'ManAzco Team'),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función en desarrollo')),
                    );
                  },
                  child: const Text('Términos'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función en desarrollo')),
                    );
                  },
                  child: const Text('Privacidad'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función en desarrollo')),
                    );
                  },
                  child: const Text('Licencias'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Cuenta'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función de eliminar cuenta en desarrollo'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
