import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../core/theme/colors.dart';
import '../../../services/presentation/screens/home_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../profile/presentation/screens/meus_dados_screen.dart';

class GanhosScreen extends StatefulWidget {
  const GanhosScreen({super.key});

  @override
  State<GanhosScreen> createState() => _GanhosScreenState();
}

class _GanhosScreenState extends State<GanhosScreen> {
  int _selectedBottomIndex = 2;

  final List<Map<String, dynamic>> _finishedServices = [
    {
      'id': '233',
      'title': 'ARGO TRACKER',
      'client': 'Luiz Henrique Simionato',
      'phone': '(19) 99681-6200',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'value': 1000.0,
      'date': DateTime.now(),
    },
    {
      'id': '133',
      'title': 'CIVIC SPORT',
      'client': 'Marina Alves',
      'phone': '(11) 99999-0000',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'value': 450.0,
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '122',
      'title': 'ONIX LTZ',
      'client': 'Pedro Souza',
      'phone': '(19) 98888-7777',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'value': 280.0,
      'date': DateTime.now().subtract(const Duration(days: 30)),
    },
  ];

  double _sumTotal(List<Map<String, dynamic>> list) {
    return list.fold<double>(0.0, (acc, e) => acc + (e['value'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final totalGanhos = _sumTotal(_finishedServices);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(title: 'MEUS GANHOS', showBackButton: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _buildTotalCard(totalGanhos),
        ),
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
          // index 2 é a tela atual (Ganhos)
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

  Widget _buildTotalCard(double total) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.attach_money, color: Colors.white, size: 32),
              SizedBox(width: 8),
              Text(
                'Ganhos Totais',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'R\$ ${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'acumulado em todos os serviços finalizados',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
