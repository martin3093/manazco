// lib/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/widgets/theme_switcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navegar a editar perfil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar y nombre
            _buildProfileHeader(),

            const SizedBox(height: 24),

            // Información personal
            _buildPersonalInfo(),

            const SizedBox(height: 16),

            // Configuraciones
            _buildSettings(),

            const SizedBox(height: 16),

            // Estadísticas
            _buildStatistics(),

            const SizedBox(height: 16),

            // Configuración de temas
            _buildThemeSettings(),

            const SizedBox(height: 16),

            // Notificaciones
            _buildNotificationSettings(),

            // AGREGAR AQUÍ LAS NUEVAS SECCIONES:
            const SizedBox(height: 16),

            // Logros/Insignias
            _buildAchievements(),

            const SizedBox(height: 16),

            // Historial de actividad
            _buildActivityHistory(),

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

            // Botón de cerrar sesión
            _buildLogoutButton(context),

            // Espacio adicional al final
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar circular con opción de cambiar
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[100],
                  child: const Icon(Icons.person, size: 50, color: Colors.blue),
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
                        // Cambiar foto de perfil
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nombre y email
            const Text(
              'Juan Pérez',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'juan.perez@email.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            // Estado o insignia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Usuario Activo',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
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

            _buildInfoRow(Icons.phone, 'Teléfono', '+1 (555) 123-4567'),
            _buildInfoRow(Icons.location_on, 'Ubicación', 'Ciudad, País'),
            _buildInfoRow(Icons.work, 'Ocupación', 'Desarrollador'),
            _buildInfoRow(
              Icons.cake,
              'Fecha de Nacimiento',
              '15 de Marzo, 1990',
            ),
            _buildInfoRow(Icons.calendar_today, 'Miembro desde', 'Enero 2024'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
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
                // Navegar a editar perfil
              },
            ),

            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Cambiar Contraseña'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navegar a cambiar contraseña
              },
            ),

            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacidad'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navegar a configuración de privacidad
              },
            ),

            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Idioma'),
              subtitle: const Text('Español'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navegar a selección de idioma
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tareas Completadas',
                    '45',
                    Icons.task_alt,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Días Activo',
                    '128',
                    Icons.calendar_today,
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
                    'Racha Actual',
                    '7 días',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Puntos',
                    '1,250',
                    Icons.stars,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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

            // Aquí puedes incluir el ThemeSettings que ya tienes
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
                // Manejar cambio de notificaciones push
              },
            ),

            SwitchListTile(
              title: const Text('Recordatorios de Tareas'),
              subtitle: const Text('Recordar tareas pendientes'),
              value: true,
              onChanged: (bool value) {
                // Manejar cambio de recordatorios
              },
            ),

            SwitchListTile(
              title: const Text('Notificaciones por Email'),
              subtitle: const Text('Recibir actualizaciones por correo'),
              value: false,
              onChanged: (bool value) {
                // Manejar cambio de email
              },
            ),
          ],
        ),
      ),
    );
  }

  // AGREGAR TODOS LOS NUEVOS MÉTODOS DESPUÉS DEL ÚLTIMO MÉTODO EXISTENTE:

  Widget _buildAchievements() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logros',
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
                  true, // conseguido
                ),
                _buildAchievementBadge(
                  'Racha de 7 días',
                  Icons.local_fire_department,
                  Colors.orange,
                  true,
                ),
                _buildAchievementBadge(
                  '50 Tareas',
                  Icons.task_alt,
                  Colors.green,
                  false, // no conseguido
                ),
                _buildAchievementBadge(
                  'Usuario Mes',
                  Icons.emoji_events,
                  Colors.purple,
                  false,
                ),
              ],
            ),
          ],
        ),
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

  Widget _buildActivityHistory() {
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Ver todo el historial
                  },
                  child: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              Icons.task_alt,
              'Completaste la tarea "Estudiar Flutter"',
              '2 horas atrás',
              Colors.green,
            ),
            _buildActivityItem(
              Icons.dark_mode,
              'Cambiaste el tema a modo oscuro',
              '1 día atrás',
              Colors.blue,
            ),
            _buildActivityItem(
              Icons.person_add,
              'Te registraste en la aplicación',
              '5 días atrás',
              Colors.purple,
            ),
          ],
        ),
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
              subtitle: const Text('Última copia: Hace 2 días'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Configurar backup
              },
            ),

            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Exportar Datos'),
              subtitle: const Text('Descargar información personal'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Exportar datos
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
                // Navegar a centro de ayuda
              },
            ),

            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Enviar Comentarios'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Enviar feedback
              },
            ),

            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Reportar Problema'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Reportar bug
              },
            ),

            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Contactar Soporte'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Contactar soporte
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
                    // Mostrar términos y condiciones
                  },
                  child: const Text('Términos'),
                ),
                TextButton(
                  onPressed: () {
                    // Mostrar política de privacidad
                  },
                  child: const Text('Privacidad'),
                ),
                TextButton(
                  onPressed: () {
                    // Mostrar licencias
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

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showLogoutDialog(context);
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
                // Eliminar cuenta
                Navigator.of(context).pop();
                // Lógica para eliminar cuenta
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Cerrar sesión
                Navigator.of(context).pop();
                // Navegar a pantalla de login
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}
