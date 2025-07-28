import 'package:flutter/material.dart';
import 'package:habbits/components/app_header.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/services/dashboard_service.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphicsPage extends StatefulWidget {
  const GraphicsPage({super.key});

  @override
  State<GraphicsPage> createState() => _GraphicsPageState();
}

class _GraphicsPageState extends State<GraphicsPage> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    setState(() => isLoading = true);
    final data = await DashboardService().getDashboardData();
    setState(() {
      dashboardData = data;
      isLoading = false;
    });
  }

  Widget _buildNoDataMessage() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.analytics_outlined,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ainda não há dados para mostrar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Continue praticando seus hábitos!\nEm breve você verá gráficos incríveis aqui.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '📊 Seus dados aparecerão aqui em breve!',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasInsufficientData() {
    if (dashboardData == null) return false;
    
    final timelineEvolution = dashboardData!["timeline_evolution"] as List? ?? [];
    final weeklyAverage = dashboardData!["weekly_average"] as List? ?? [];
    final hourlyDistribution = dashboardData!["hourly_distribution"] as List? ?? [];
    
    // Se todos os arrays estão vazios, consideramos dados insuficientes
    return timelineEvolution.isEmpty && weeklyAverage.isEmpty && hourlyDistribution.isEmpty;
  }

  Widget _buildInsufficientDataMessage() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timeline,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dados insuficientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Você precisa completar mais hábitos para\nver estatísticas detalhadas nos gráficos.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '📈 Continue praticando para ver seus gráficos!',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(title: 'Gráficos', subtitle: 'Veja suas métricas'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : dashboardData == null
                      ? _buildNoDataMessage()
                      : _hasInsufficientData()
                          ? _buildInsufficientDataMessage()
                          : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sua evolução ao longo do tempo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: _EvolutionChart(
                                data: List<Map<String, dynamic>>.from(
                                  dashboardData!["timeline_evolution"] ?? [],
                                ),
                              ),
                            ),
                            const SizedBox(height: 64),
                            const Text(
                              'Conclusões por dia da semana',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 550,
                              child: _WeeklyBarChart(
                                data: List<Map<String, dynamic>>.from(
                                  dashboardData!["weekly_average"] ?? [],
                                ),
                              ),
                            ),
                            const SizedBox(height: 64),
                            const Text(
                              'Distribuição por horário do dia',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 600,
                              child: _PieChart(
                                data: List<Map<String, dynamic>>.from(
                                  dashboardData!["hourly_distribution"] ?? [],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
            ),
          ),
        ],
      ),
          );
    }
  }
  
  class _EvolutionChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _EvolutionChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.show_chart,
                  size: 48,
                  color: AppColors.gray,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhum dado de evolução',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Continue praticando seus hábitos para ver sua evolução ao longo do tempo.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final maxValue = data.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b);
    
    // Se todos os valores são zero, mostrar mensagem específica
    if (maxValue == 0) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_flat,
                  size: 48,
                  color: AppColors.gray,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhuma atividade registrada',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Complete alguns hábitos para ver sua evolução no gráfico.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    final spots = data.asMap().entries.map((entry) {
      final value = entry.value['count'] as int;
      final normalizedValue = maxValue > 0 ? value / maxValue : 0.0;
      return FlSpot(entry.key.toDouble(), normalizedValue * 5);
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xFFE5E5E5),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: (data.length / 6).ceil().toDouble(),
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= data.length) return const Text('');
                    final date = data[value.toInt()]['date'] as String;
                    final label = _getShortDateLabel(date);
                    return Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final actualValue = maxValue > 0 ? ((maxValue * (5 - value)) / 5).round() : 5 - value.toInt();
                    return Text(
                      actualValue.toString(),
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (data.length - 1).toDouble(),
            minY: 0,
            maxY: 5,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7EA18D).withOpacity(0.3),
                    const Color(0xFF7EA18D).withOpacity(0.05),
                  ],
                ),
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    if (index == spots.length - 1) {
                      return FlDotCirclePainter(
                        radius: 8,
                        color: const Color(0xFF7EA18D).withOpacity(0.3),
                        strokeWidth: 0,
                      );
                    }
                    return FlDotCirclePainter(
                      radius: 2,
                      color: const Color(0xFF2D5A3D),
                      strokeWidth: 0,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7EA18D).withOpacity(0.3),
                      const Color(0xFF7EA18D).withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShortDateLabel(String date) {
    final parts = date.split('-');
    if (parts.length >= 3) {
      final day = parts[2];
      final month = parts[1];
      return '$day/$month';
    }
    return date;
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _WeeklyBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 48,
                  color: AppColors.gray,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhum dado semanal',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Continue praticando seus hábitos para ver suas conclusões por dia da semana.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final maxValue = data.map((e) => e['average'] as double).reduce((a, b) => a > b ? a : b);
    
    // Se todas as médias são zero, mostrar mensagem específica
    if (maxValue == 0) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: AppColors.gray,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhuma conclusão registrada',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Complete hábitos durante a semana para ver sua média por dia.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    final barGroups = data.asMap().entries.map((entry) {
      final average = entry.value['average'] as double;
      final dayOfWeek = entry.value['day_of_week'] as String;
      final isSaturday = dayOfWeek == "Sábado";
      
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: average,
            color: const Color(0xFF2D5A3D),
            width: 25,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxValue,
              color: const Color(0xFFB7D0C1),
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxValue,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final dayOfWeek = data[value.toInt()]['day_of_week'] as String;
                    final isSaturday = dayOfWeek == "Sábado";
                    return Text(
                      _getShortDayLabel(dayOfWeek),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontWeight: isSaturday ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }

  String _getShortDayLabel(String dayOfWeek) {
    switch (dayOfWeek) {
      case "Segunda": return "SEG";
      case "Terça": return "TER";
      case "Quarta": return "QUA";
      case "Quinta": return "QUI";
      case "Sexta": return "SEX";
      case "Sábado": return "SAB";
      case "Domingo": return "DOM";
      default: return dayOfWeek;
    }
  }
}

class _PieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _PieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 48,
                  color: AppColors.gray,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhum horário registrado',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Complete hábitos em diferentes horários para ver a distribuição.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final total = data.map((e) => e['count'] as int).reduce((a, b) => a + b);
    if (total == 0) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.pie_chart_outline,
                  size: 48,
                  color: AppColors.gray,
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhum dado por horário',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Continue praticando seus hábitos para ver a distribuição por horário.',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final sections = data.asMap().entries.map((entry) {
      final count = entry.value['count'] as int;
      final percentage = total > 0 ? (count / total * 100).round() : 0;
      final timeRange = entry.value['time_range'] as String;
      
      return PieChartSectionData(
        color: _getColorForIndex(entry.key),
        value: count.toDouble(),
        title: percentage > 0 ? '$percentage%' : '',
        radius: 120,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(data, total),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(List<Map<String, dynamic>> data, int total) {
    return Column(
      children: data.map((item) {
        final timeRange = item['time_range'] as String;
        final count = item['count'] as int;
        final percentage = total > 0 ? (count / total * 100).round() : 0;
        final color = _getColorForIndex(data.indexOf(item));
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getTimeLabel(timeRange),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getTimeLabel(String timeRange) {
    switch (timeRange) {
      case "00h–06h": return "12:00 AM - 6:00 AM";
      case "06h–09h": return "6:00 AM - 9:00 AM";
      case "09h–12h": return "9:00 AM - 12:00 PM";
      case "12h–15h": return "12:00 PM - 3:00 PM";
      case "15h–18h": return "3:00 PM - 6:00 PM";
      case "18h–21h": return "6:00 PM - 9:00 PM";
      case "21h–24h": return "9:00 PM - 12:00 AM";
      default: return timeRange;
    }
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF7EA18D), // Verde principal
      const Color(0xFF4A7A5F), // Verde escuro
      const Color(0xFFB7D0C1), // Verde claro
      const Color(0xFFE6C77A), // Amarelo/dourado suave
      const Color(0xFFE6A87A), // Laranja queimado
      const Color(0xFF4A6A7F), // Azul petróleo
      const Color(0xFF8C7EA1), // Roxo acinzentado
    ];
    return colors[index % colors.length];
  }
}
