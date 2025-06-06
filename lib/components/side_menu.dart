import 'package:flutter/material.dart';
import 'package:manazco/bloc/theme/theme_state.dart';
import 'package:manazco/helpers/dialog_helper.dart';
import 'package:manazco/views/acerca_screen.dart';
import 'package:manazco/views/contador_screen.dart';
import 'package:manazco/views/home_screen.dart';
import 'package:manazco/views/mi_app_screen.dart';
import 'package:manazco/views/noticia_screen.dart';
import 'package:manazco/views/profile_screen.dart';
import 'package:manazco/views/quote_screen.dart';
import 'package:manazco/views/start_screen.dart';
import 'package:manazco/views/welcome_screen.dart';
import 'package:manazco/views/tarea_screen.dart';
import 'package:manazco/views/dashboard_screen.dart';
import 'package:manazco/widgets/theme_switcher.dart'; // 🎨 Importar ThemeSwitcher
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/theme/theme_cubit.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.primary,
      child: Column(
        children: [
          // Header que simula el AppBar
          Container(
            height:
                AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top,
            width: double.infinity,
            color: theme.colorScheme.primary,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),

          // Lista de opciones del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // === NAVEGACIÓN PRINCIPAL ===
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Inicio'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                ),

                // === FUNCIONALIDADES ===
                const Divider(color: Colors.white24, thickness: 1, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'FUNCIONALIDADES',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Cotizaciones'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuoteScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.task),
                  title: const Text('Tareas'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TareaScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text('Noticias'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NoticiaScreen(),
                      ),
                    );
                  },
                ),

                // === APLICACIONES ===
                const Divider(color: Colors.white24, thickness: 1, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'APLICACIONES',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.apps),
                  title: const Text('Mi App'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MiAppScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.numbers),
                  title: const Text('Contador'),
                  onTap: () {
                    Navigator.pushReplacement(
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
                  leading: const Icon(Icons.stars),
                  title: const Text('Juego'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartScreen(),
                      ),
                    );
                  },
                ),

                // === CONFIGURACIÓN ===
                const Divider(color: Colors.white24, thickness: 1, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'CONFIGURACIÓN',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                // 🎨 OPCIÓN DE TEMA - NUEVA
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    // Extraer el ThemeMode del estado
                    final themeMode = themeState.themeMode;

                    return ListTile(
                      leading: Icon(
                        themeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : themeMode == ThemeMode.light
                            ? Icons.light_mode
                            : Icons.brightness_auto,
                      ),
                      title: const Text('Tema'),
                      subtitle: Text(
                        themeMode == ThemeMode.dark
                            ? 'Oscuro'
                            : themeMode == ThemeMode.light
                            ? 'Claro'
                            : 'Automático',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      ),
                      onTap: () {
                        _showThemeDialog(context);
                      },
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Mi Perfil'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),

                // === INFORMACIÓN ===
                const Divider(color: Colors.white24, thickness: 1, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'INFORMACIÓN',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Acerca de'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AcercaScreen(),
                      ),
                    );
                  },
                ),

                // === SESIÓN ===
                const Divider(color: Colors.white24, thickness: 1, height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    DialogHelper.mostrarDialogoCerrarSesion(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 Diálogo para seleccionar tema
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final currentTheme = themeState.themeMode;

            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.palette, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  const Text('Seleccionar Tema'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildThemeOption(
                    context: context,
                    icon: Icons.light_mode,
                    title: 'Tema Claro',
                    subtitle: 'Interfaz con colores claros',
                    themeMode: ThemeMode.light,
                    isSelected: currentTheme == ThemeMode.light,
                  ),
                  const SizedBox(height: 8),
                  _buildThemeOption(
                    context: context,
                    icon: Icons.dark_mode,
                    title: 'Tema Oscuro',
                    subtitle: 'Interfaz con colores oscuros',
                    themeMode: ThemeMode.dark,
                    isSelected: currentTheme == ThemeMode.dark,
                  ),
                  const SizedBox(height: 8),
                  _buildThemeOption(
                    context: context,
                    icon: Icons.brightness_auto,
                    title: 'Automático',
                    subtitle: 'Sigue la configuración del sistema',
                    themeMode: ThemeMode.system,
                    isSelected: currentTheme == ThemeMode.system,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeMode themeMode,
    required bool isSelected,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // ✅ CORRECCIÓN: Usar métodos existentes según el ThemeMode
        switch (themeMode) {
          case ThemeMode.light:
            context.read<ThemeCubit>().setLightTheme(); // ✅ Método correcto
            break;
          case ThemeMode.dark:
            context.read<ThemeCubit>().setDarkTheme(); // ✅ Método correcto
            break;
          case ThemeMode.system:
            context.read<ThemeCubit>().setSystemTheme(); // ✅ Método correcto
            break;
        }

        Navigator.of(context).pop();

        // Mostrar confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text('Tema cambiado a ${_getThemeName(themeMode)}'),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  String _getThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Automático';
    }
  }
}
