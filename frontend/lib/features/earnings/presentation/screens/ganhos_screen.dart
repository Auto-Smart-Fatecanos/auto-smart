import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../core/theme/colors.dart';
import '../../../services/presentation/screens/home_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../profile/presentation/screens/meus_dados_screen.dart';
import '../../../orcamentos/model/repository/orcamento_repository_impl.dart';

class GanhosScreen extends StatefulWidget {
  const GanhosScreen({super.key});

  @override
  State<GanhosScreen> createState() => _GanhosScreenState();
}

class _GanhosScreenState extends State<GanhosScreen>
    with SingleTickerProviderStateMixin {
  int _selectedBottomIndex = 2;

  final OrcamentoRepositoryImpl _repository = OrcamentoRepositoryImpl();

  bool _isLoading = true;
  double _totalGanhos = 0.0;
  String? _error;
  Map<int, double> _ganhosPorMes = {};

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadGanhos();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadGanhos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final earningsData = await _repository.getEarnings();

      Map<int, double> ganhosMes = {};

      // Inicializar últimos 6 meses com 0
      final now = DateTime.now();
      for (int i = 5; i >= 0; i--) {
        final mes = DateTime(now.year, now.month - i, 1);
        ganhosMes[mes.month] = 0.0;
      }

      // Preencher com os dados do backend
      for (final ganhoMes in earningsData.ganhosPorMes) {
        if (ganhosMes.containsKey(ganhoMes.mes)) {
          ganhosMes[ganhoMes.mes] = ganhoMes.total;
        }
      }

      setState(() {
        _totalGanhos = earningsData.totalGanhos;
        _ganhosPorMes = ganhosMes;
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar ganhos: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'MEUS GANHOS',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Header padronizado
          Container(
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                'SERVIÇOS FINALIZADOS',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          // Conteúdo
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() => _selectedBottomIndex = index);
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          }
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MeusDadosScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                color: Color(0xFF2E7D32),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Calculando seus ganhos...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red.shade400,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Ops! Algo deu errado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadGanhos,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Tentar novamente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card de Total
            _buildTotalCard(),
            const SizedBox(height: 20),
            // Gráfico
            _buildChartCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Total de Ganhos',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'R\$ ${_formatCurrency(_totalGanhos)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Ganhos por Mês',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.primary,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        'R\$ ${rod.toY.toStringAsFixed(2)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final meses = ['', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
                                        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
                        final index = value.toInt();
                        if (index >= 0 && index < _ganhosPorMes.keys.length) {
                          final mes = _ganhosPorMes.keys.toList()[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              meses[mes],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatShortCurrency(value),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getMaxY() / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final valores = _ganhosPorMes.values.toList();
    return List.generate(valores.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: valores[index],
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }

  double _getMaxY() {
    if (_ganhosPorMes.isEmpty) return 100;
    final max = _ganhosPorMes.values.reduce((a, b) => a > b ? a : b);
    return max == 0 ? 100 : max * 1.2;
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(2);
  }

  String _formatShortCurrency(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
