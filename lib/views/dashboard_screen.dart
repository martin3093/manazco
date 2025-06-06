import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manazco/bloc/noticia/noticia_bloc.dart';
import 'package:manazco/bloc/noticia/noticia_state.dart';
import 'package:manazco/bloc/noticia/noticia_event.dart';
// Asegúrate de que el archivo noticia_event.dart exporta la clase FetchNoticias
import 'package:manazco/bloc/tarea/tarea_bloc.dart';
import 'package:manazco/bloc/tarea/tarea_state.dart';
import 'package:manazco/bloc/tarea/tarea_event.dart'
    show LoadTareasEvent, LoadTareasEvent;
import 'package:manazco/bloc/theme/theme_cubit.dart';
import 'package:manazco/components/side_menu.dart';
import 'package:manazco/widgets/theme_switcher.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:manazco/services/export_service.dart';
import 'package:share_plus/share_plus.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cargar datos al entrar al dashboard
    context.read<NoticiaBloc>().add(FetchNoticiasEvent());
    context.read<TareaBloc>().add(LoadTareasEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Estadísticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refrescar datos
              context.read<NoticiaBloc>().add(FetchNoticiasEvent());
              context.read<TareaBloc>().add(LoadTareasEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deatos actualizados')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportDashboard(context),
          ),
          const ThemeSwitcher(),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const SideMenu(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NoticiaBloc, NoticiaState>(
            listener: (context, state) {
              if (state is NoticiaError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error cargando noticias: ${state.error.message}',
                    ), // ✅ Correcto
                  ),
                );
              }
            },
          ),
          BlocListener<TareaBloc, TareaState>(
            listener: (context, state) {
              if (state is TareaError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error cargando tareas: ${state.error.message}',
                    ), // ✅ Correcto
                  ),
                );
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<NoticiaBloc>().add(FetchNoticiasEvent());
            context.read<TareaBloc>().add(LoadTareasEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen ejecutivo con datos reales
                _buildExecutiveSummaryReal(),

                const SizedBox(height: 24),

                // Métricas de noticias reales
                _buildNoticiasMetricsReal(),

                const SizedBox(height: 24),

                // Métricas de tareas reales
                _buildTareasMetricsReal(),

                const SizedBox(height: 24),

                // Gráficos con datos reales
                _buildChartsWithRealData(),

                const SizedBox(height: 24),

                // Actividad reciente real
                _buildActivitySectionReal(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExecutiveSummaryReal() {
    return BlocBuilder<NoticiaBloc, NoticiaState>(
      builder: (context, noticiaState) {
        return BlocBuilder<TareaBloc, TareaState>(
          builder: (context, tareaState) {
            // Calcular datos reales
            final totalNoticias =
                noticiaState is NoticiaLoaded
                    ? noticiaState.noticias.length
                    : 0;
            final totalReportes =
                noticiaState is NoticiaLoaded
                    ? noticiaState.noticias.fold<int>(
                      0,
                      (sum, n) => sum + ((n.contadorReportes ?? 0) as int),
                    )
                    : 0;

            final totalTareas =
                tareaState is TareaLoaded ? tareaState.tareas.length : 0;
            final tareasCompletadas =
                tareaState is TareaLoaded
                    ? tareaState.tareas.where((t) => t.completado).length
                    : 0;
            final progresoTareas =
                totalTareas > 0
                    ? (tareasCompletadas / totalTareas * 100).toInt()
                    : 0;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dashboard, color: Colors.blue, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Resumen Ejecutivo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (noticiaState is NoticiaLoading ||
                            tareaState is TareaLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🔧 SOLUCIÓN 1: Layout responsive con Wrap
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Si la pantalla es muy pequeña, usar Column
                        if (constraints.maxWidth < 600) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSummaryCard(
                                      title: 'Total Noticias',
                                      value: totalNoticias.toString(),
                                      icon: Icons.article,
                                      color: Colors.blue,
                                      trend: _calculateTrend(
                                        totalNoticias,
                                        'noticias',
                                      ),
                                      isPositive: totalNoticias > 0,
                                    ),
                                  ),
                                  const SizedBox(width: 8), // ✅ Reducido de 12
                                  Expanded(
                                    child: _buildSummaryCard(
                                      title: 'Progreso Tareas',
                                      value: '$progresoTareas%',
                                      icon: Icons.task_alt,
                                      color: Colors.green,
                                      trend: _calculateTrend(
                                        progresoTareas,
                                        'progreso',
                                      ),
                                      isPositive: progresoTareas >= 50,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSummaryCard(
                                      title: 'Total Reportes',
                                      value: totalReportes.toString(),
                                      icon: Icons.flag,
                                      color: Colors.orange,
                                      trend: _calculateTrend(
                                        totalReportes,
                                        'reportes',
                                      ),
                                      isPositive: totalReportes == 0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildSummaryCard(
                                      title: 'Tareas Activas',
                                      value:
                                          (totalTareas - tareasCompletadas)
                                              .toString(),
                                      icon: Icons.pending_actions,
                                      color: Colors.purple,
                                      trend: _calculateTrend(
                                        totalTareas - tareasCompletadas,
                                        'pendientes',
                                      ),
                                      isPositive:
                                          totalTareas - tareasCompletadas <=
                                          totalTareas / 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          // Pantalla grande: usar Row original pero con menos espaciado
                          return Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCard(
                                  title: 'Total Noticias',
                                  value: totalNoticias.toString(),
                                  icon: Icons.article,
                                  color: Colors.blue,
                                  trend: _calculateTrend(
                                    totalNoticias,
                                    'noticias',
                                  ),
                                  isPositive: totalNoticias > 0,
                                ),
                              ),
                              const SizedBox(width: 8), // ✅ Reducido
                              Expanded(
                                child: _buildSummaryCard(
                                  title: 'Progreso Tareas',
                                  value: '$progresoTareas%',
                                  icon: Icons.task_alt,
                                  color: Colors.green,
                                  trend: _calculateTrend(
                                    progresoTareas,
                                    'progreso',
                                  ),
                                  isPositive: progresoTareas >= 50,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSummaryCard(
                                  title: 'Total Reportes',
                                  value: totalReportes.toString(),
                                  icon: Icons.flag,
                                  color: Colors.orange,
                                  trend: _calculateTrend(
                                    totalReportes,
                                    'reportes',
                                  ),
                                  isPositive: totalReportes == 0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSummaryCard(
                                  title: 'Tareas Activas',
                                  value:
                                      (totalTareas - tareasCompletadas)
                                          .toString(),
                                  icon: Icons.pending_actions,
                                  color: Colors.purple,
                                  trend: _calculateTrend(
                                    totalTareas - tareasCompletadas,
                                    'pendientes',
                                  ),
                                  isPositive:
                                      totalTareas - tareasCompletadas <=
                                      totalTareas / 2,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _calculateTrend(int value, String type) {
    // Lógica simple para calcular tendencias
    // En una app real, compararías con datos históricos
    switch (type) {
      case 'noticias':
        return value > 10 ? '+${(value * 0.1).toInt()}%' : '+0%';
      case 'progreso':
        return value >= 70
            ? '+5%'
            : value >= 50
            ? '+2%'
            : '-1%';
      case 'reportes':
        return value > 5 ? '+${(value * 0.2).toInt()}%' : '0%';
      case 'pendientes':
        return value > 10 ? '+3%' : '-2%';
      default:
        return '0%';
    }
  }

  Widget _buildNoticiasMetricsReal() {
    return BlocBuilder<NoticiaBloc, NoticiaState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.article, color: Colors.blue, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Métricas de Noticias',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (state is NoticiaLoading) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else if (state is NoticiaLoaded) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Total Noticias',
                          state.noticias.length.toString(),
                          Icons.article,
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'Reportes Totales',
                          state.noticias
                              .fold<int>(
                                0,
                                (sum, n) =>
                                    sum + ((n.contadorReportes ?? 0) as int),
                              )
                              .toString(),
                          Icons.flag,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Comentarios',
                          state.noticias
                              .fold<int>(
                                0,
                                (sum, n) =>
                                    sum + ((n.contadorComentarios ?? 0) as int),
                              )
                              .toString(),
                          Icons.comment,
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'Promedio Reportes',
                          state.noticias.isNotEmpty
                              ? (state.noticias.fold<int>(
                                        0,
                                        (sum, n) =>
                                            sum + (n.contadorReportes ?? 0),
                                      ) /
                                      state.noticias.length)
                                  .toStringAsFixed(1)
                              : '0.0',
                          Icons.analytics,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  // Mostrar últimas noticias
                  if (state.noticias.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      'Últimas Noticias:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...state.noticias
                        .take(3)
                        .map(
                          (noticia) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    noticia.titulo,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if ((noticia.contadorReportes ?? 0) > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${noticia.contadorReportes} reportes',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ] else if (state is NoticiaError) ...[
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.error.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<NoticiaBloc>().add(
                              (FetchNoticiasEvent()),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Center(
                    child: Text('No hay datos de noticias disponibles'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTareasMetricsReal() {
    return BlocBuilder<TareaBloc, TareaState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.task, color: Colors.green, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Métricas de Tareas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (state is TareaLoading) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else if (state is TareaLoaded) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Total Tareas',
                          state.tareas.length.toString(),
                          Icons.list,
                          Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'Completadas',
                          state.tareas
                              .where((t) => t.completado)
                              .length
                              .toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Pendientes',
                          state.tareas
                              .where((t) => !t.completado)
                              .length
                              .toString(),
                          Icons.pending,
                          Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'Progreso',
                          state.tareas.isNotEmpty
                              ? '${((state.tareas.where((t) => t.completado).length / state.tareas.length) * 100).toInt()}%'
                              : '0%',
                          Icons.trending_up,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  // Mostrar tareas pendientes importantes
                  if (state.tareas.where((t) => !t.completado).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      'Tareas Pendientes:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...state.tareas
                        .where((t) => !t.completado)
                        .take(3)
                        .map(
                          (tarea) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle_outlined,
                                  size: 8,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tarea.titulo,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Pendiente',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ] else if (state is TareaError) ...[
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.error.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
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
                  const Center(
                    child: Text('No hay datos de tareas disponibles'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartsWithRealData() {
    return BlocBuilder<TareaBloc, TareaState>(
      builder: (context, tareaState) {
        return BlocBuilder<NoticiaBloc, NoticiaState>(
          builder: (context, noticiaState) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildRealPieChart(tareaState)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildRealBarChart(noticiaState)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRealLineChart(tareaState, noticiaState),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRealPieChart(TareaState tareaState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribución de Tareas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child:
                  tareaState is TareaLoaded && tareaState.tareas.isNotEmpty
                      ? _buildPieChartWithData(tareaState.tareas)
                      : const Center(child: Text('Sin datos de tareas')),
            ),
            const SizedBox(height: 16),
            if (tareaState is TareaLoaded && tareaState.tareas.isNotEmpty) ...[
              Column(
                children: [
                  _buildLegendItem(
                    'Completadas (${tareaState.tareas.where((t) => t.completado).length})',
                    Colors.green,
                  ),
                  _buildLegendItem(
                    'Pendientes (${tareaState.tareas.where((t) => !t.completado).length})',
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartWithData(List<dynamic> tareas) {
    final completadas = tareas.where((t) => t.completado).length;
    final pendientes = tareas.where((t) => !t.completado).length;
    final total = tareas.length;

    if (total == 0) {
      return const Center(child: Text('No hay tareas'));
    }

    return PieChart(
      PieChartData(
        sections: [
          if (completadas > 0)
            PieChartSectionData(
              color: Colors.green,
              value: completadas.toDouble(),
              title: '${((completadas / total) * 100).toInt()}%',
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (pendientes > 0)
            PieChartSectionData(
              color: Colors.orange,
              value: pendientes.toDouble(),
              title: '${((pendientes / total) * 100).toInt()}%',
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildRealBarChart(NoticiaState noticiaState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reportes por Noticia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child:
                  noticiaState is NoticiaLoaded &&
                          noticiaState.noticias.isNotEmpty
                      ? _buildBarChartWithData(noticiaState.noticias)
                      : const Center(child: Text('Sin datos de noticias')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartWithData(List<dynamic> noticias) {
    // Tomar las primeras 5 noticias con más reportes
    final noticiasConReportes =
        noticias.where((n) => (n.contadorReportes ?? 0) > 0).take(5).toList();

    if (noticiasConReportes.isEmpty) {
      return const Center(child: Text('No hay reportes'));
    }

    final maxReportes =
        noticiasConReportes
            .map((n) => n.contadorReportes ?? 0)
            .reduce((a, b) => a > b ? a : b)
            .toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxReportes > 0 ? maxReportes + 1 : 10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < noticiasConReportes.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'N${index + 1}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            noticiasConReportes.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: (entry.value.contadorReportes ?? 0).toDouble(),
                    color: Colors.red,
                    width: 20,
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildRealLineChart(TareaState tareaState, NoticiaState noticiaState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tendencia Semanal (Datos Simulados)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Basado en datos actuales',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildLineChartWithRealData(tareaState, noticiaState),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Noticias', Colors.blue),
                const SizedBox(width: 20),
                _buildLegendItem('Tareas', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChartWithRealData(
    TareaState tareaState,
    NoticiaState noticiaState,
  ) {
    // Generar datos simulados basados en los datos reales
    final totalNoticias =
        noticiaState is NoticiaLoaded
            ? noticiaState.noticias.length.toDouble()
            : 0.0;
    final totalTareas =
        tareaState is TareaLoaded ? tareaState.tareas.length.toDouble() : 0.0;

    // Crear tendencia simulada
    final noticiasSpots = List.generate(7, (index) {
      final variation = (index - 3) * 0.1; // Variación simulada
      return FlSpot(
        index.toDouble(),
        (totalNoticias * (1 + variation)).clamp(0, double.infinity),
      );
    });

    final tareasSpots = List.generate(7, (index) {
      final variation = (index - 2) * 0.15; // Variación simulada diferente
      return FlSpot(
        index.toDouble(),
        (totalTareas * (1 + variation)).clamp(0, double.infinity),
      );
    });

    final maxY = [
      ...noticiasSpots.map((s) => s.y),
      ...tareasSpots.map((s) => s.y),
    ].reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Lun');
                  case 1:
                    return const Text('Mar');
                  case 2:
                    return const Text('Mié');
                  case 3:
                    return const Text('Jue');
                  case 4:
                    return const Text('Vie');
                  case 5:
                    return const Text('Sáb');
                  case 6:
                    return const Text('Dom');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: maxY > 0 ? maxY + 2 : 10,
        lineBarsData: [
          LineChartBarData(
            spots: noticiasSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
          LineChartBarData(
            spots: tareasSpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySectionReal() {
    return BlocBuilder<NoticiaBloc, NoticiaState>(
      builder: (context, noticiaState) {
        return BlocBuilder<TareaBloc, TareaState>(
          builder: (context, tareaState) {
            final activities = <Map<String, dynamic>>[];

            // Agregar actividades de noticias
            if (noticiaState is NoticiaLoaded &&
                noticiaState.noticias.isNotEmpty) {
              final ultimasNoticias = noticiaState.noticias.take(2);
              for (final noticia in ultimasNoticias) {
                activities.add({
                  'title': 'Nueva noticia: "${noticia.titulo}"',
                  'time':
                      'Hace ${DateTime.now().difference(DateTime.now().subtract(const Duration(hours: 2))).inHours} horas',
                  'icon': Icons.article,
                  'color': Colors.blue,
                });
              }
            }

            // Agregar actividades de tareas
            if (tareaState is TareaLoaded && tareaState.tareas.isNotEmpty) {
              final tareasCompletadas = tareaState.tareas
                  .where((t) => t.completado)
                  .take(2);
              for (final tarea in tareasCompletadas) {
                activities.add({
                  'title': 'Tarea completada: "${tarea.titulo}"',
                  'time':
                      'Hace ${DateTime.now().difference(DateTime.now().subtract(const Duration(hours: 1))).inHours + 1} horas',
                  'icon': Icons.check_circle,
                  'color': Colors.green,
                });
              }
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timeline, color: Colors.purple, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Actividad Reciente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (activities.isEmpty) ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No hay actividad reciente'),
                        ),
                      ),
                    ] else ...[
                      ...activities
                          .map(
                            (activity) => _buildActivityItem(
                              activity['title'],
                              activity['time'],
                              activity['icon'],
                              activity['color'],
                            ),
                          )
                          .toList(),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Métodos auxiliares (sin cambios)
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isPositive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 10,
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
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
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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

  // Función para exportar dashboard - VERSIÓN ACTUALIZADA
  void _exportDashboard(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Exportar Dashboard'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text('Exportar como PDF'),
                  subtitle: const Text('Reporte completo con gráficos'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handlePDFExport(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: const Text('Exportar como Excel'),
                  subtitle: const Text('Datos en hojas de cálculo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handleExcelExport(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Compartir Dashboard'),
                  subtitle: const Text('Enviar por mensaje o email'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareBasicReport(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }

  // Manejar exportación PDF
  Future<void> _handlePDFExport(BuildContext context) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Generando PDF...'),
                ],
              ),
            ),
      );

      // Recopilar datos del dashboard
      final dashboardData = await _collectDashboardData(context);

      // Generar PDF
      await ExportService.exportToPDF(
        context: context,
        dashboardData: dashboardData,
      );

      // Cerrar loading
      Navigator.pop(context);

      // Mostrar éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF generado y compartido exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Cerrar loading si está abierto
      Navigator.pop(context);

      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generando PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Manejar exportación Excel
  Future<void> _handleExcelExport(BuildContext context) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Generando Excel...'),
                ],
              ),
            ),
      );

      // Recopilar datos del dashboard
      final dashboardData = await _collectDashboardData(context);

      // Generar Excel
      await ExportService.exportToExcel(
        context: context,
        dashboardData: dashboardData,
      );

      // Cerrar loading
      Navigator.pop(context);

      // Mostrar éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Excel generado y compartido exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Cerrar loading si está abierto
      Navigator.pop(context);

      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generando Excel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Recopilar datos del dashboard
  Future<Map<String, dynamic>> _collectDashboardData(
    BuildContext context,
  ) async {
    final noticiaState = context.read<NoticiaBloc>().state;
    final tareaState = context.read<TareaBloc>().state;

    // Extraer datos de noticias
    final noticias = noticiaState is NoticiaLoaded ? noticiaState.noticias : [];
    final totalNoticias = noticias.length;
    final totalReportes = noticias.fold<int>(
      0,
      (sum, n) => sum + (n.contadorReportes as int? ?? 0),
    );
    final totalComentarios = noticias.fold<int>(
      0,
      (sum, n) => sum + (n.contadorComentarios as int? ?? 0),
    );

    // Extraer datos de tareas
    final tareas = tareaState is TareaLoaded ? tareaState.tareas : [];
    final totalTareas = tareas.length;
    final tareasCompletadas = tareas.where((t) => t.completado).length;
    final progresoTareas =
        totalTareas > 0 ? (tareasCompletadas / totalTareas * 100).toInt() : 0;

    // Crear actividades
    final activities = <Map<String, dynamic>>[];

    // Actividades de noticias
    for (final noticia in noticias.take(3)) {
      activities.add({
        'title': 'Nueva noticia: "${noticia.titulo}"',
        'time': 'Hace 2 horas',
      });
    }

    // Actividades de tareas
    for (final tarea in tareas.where((t) => t.completado).take(3)) {
      activities.add({
        'title': 'Tarea completada: "${tarea.titulo}"',
        'time': 'Hace 1 hora',
      });
    }

    return {
      'totalNoticias': totalNoticias,
      'totalReportes': totalReportes,
      'totalComentarios': totalComentarios,
      'progresoTareas': progresoTareas,
      'tareasActivas': totalTareas - tareasCompletadas,
      'noticias':
          noticias
              .map(
                (n) => {
                  'titulo': n.titulo,
                  'contadorReportes': n.contadorReportes ?? 0,
                  'contadorComentarios': n.contadorComentarios ?? 0,
                },
              )
              .toList(),
      'tareas':
          tareas
              .map(
                (t) => {
                  'titulo': t.titulo,
                  'descripcion': t.descripcion,
                  'completado': t.completado,
                },
              )
              .toList(),
      'activities': activities,
    };
  }

  // Compartir reporte básico
  void _shareBasicReport(BuildContext context) {
    final noticiaState = context.read<NoticiaBloc>().state;
    final tareaState = context.read<TareaBloc>().state;

    final totalNoticias =
        noticiaState is NoticiaLoaded ? noticiaState.noticias.length : 0;
    final totalTareas =
        tareaState is TareaLoaded ? tareaState.tareas.length : 0;
    final tareasCompletadas =
        tareaState is TareaLoaded
            ? tareaState.tareas.where((t) => t.completado).length
            : 0;

    final reportText = '''
📊 Dashboard ManAzco - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

📰 Noticias: $totalNoticias
✅ Tareas: $totalTareas (${tareasCompletadas} completadas)
📈 Progreso: ${totalTareas > 0 ? ((tareasCompletadas / totalTareas) * 100).toInt() : 0}%

#ManAzco #Dashboard #Estadisticas
  ''';

    Share.share(reportText);
  }
}
