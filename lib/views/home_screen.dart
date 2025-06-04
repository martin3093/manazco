// lib/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/components/side_menu.dart';
import '../bloc/theme/theme_cubit.dart';
import '../bloc/theme/theme_state.dart';
import '../widgets/theme_switcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Volver',
                )
                : null,
        title: const Text('ManAzco'),
        actions: [const ThemeSwitcher(), const SizedBox(width: 8)],
      ),
      drawer: const SideMenu(),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del tema actual
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tema Actual',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('Modo: ${themeState.themeName}'),
                        Text(
                          'Es oscuro: ${themeState.isDarkMode ? "Sí" : "No"}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Configuración de tema completa
                const ThemeSettings(),

                const SizedBox(height: 16),

                // Ejemplo de componentes con el tema
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Componentes de ejemplo',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),

                        // Botones
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Elevado'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Texto'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Campo de texto
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Campo de ejemplo',
                            hintText: 'Escribe algo aquí...',
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Controles de alternancia rápida
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                context.read<ThemeCubit>().setLightTheme();
                              },
                              icon: const Icon(Icons.light_mode),
                              label: const Text('Claro'),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                context.read<ThemeCubit>().setDarkTheme();
                              },
                              icon: const Icon(Icons.dark_mode),
                              label: const Text('Oscuro'),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                context.read<ThemeCubit>().setSystemTheme();
                              },
                              icon: const Icon(Icons.settings_suggest),
                              label: const Text('Auto'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const ThemeToggleButton(),
    );
  }
}
