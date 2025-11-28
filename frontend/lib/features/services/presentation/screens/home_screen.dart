import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../widgets/service_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../profile/presentation/screens/meus_dados_screen.dart';
import '../../../earnings/presentation/screens/ganhos_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import 'service_details_screen.dart';
import '../../../budget/presentation/screens/budget_screen.dart';
import '../../../orcamentos/model/orcamento_model.dart';
import '../../../orcamentos/model/repository/orcamento_repository_impl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  int _selectedBottomIndex = 0;
  final List<String> _tabs = ['PENDENTES', 'EM MANUTENÇÃO', 'FINALIZADOS'];

  List<OrcamentoModel> _orcamentos = [];
  bool _isLoading = true;
  String? _error;
  final OrcamentoRepositoryImpl _repository = OrcamentoRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _loadOrcamentos();
  }

  Map<String, dynamic> _mapStatusToDisplay(String status) {
    switch (status.toUpperCase()) {
      case 'PENDENTE':
        return {
          'text': 'PENDENTE',
          'color': Colors.orange,
        };
      case 'EM_MANUTENCAO':
        return {
          'text': 'EM MANUTENÇÃO',
          'color': Colors.blue,
        };
      case 'REPROVADO':
        return {
          'text': 'REPROVADO',
          'color': Colors.red,
        };
      case 'FINALIZADO':
        return {
          'text': 'FINALIZADO',
          'color': Colors.green,
        };
      case 'SERVICO_EXTERNO':
        return {
          'text': 'SERVIÇO EXTERNO',
          'color': Colors.purple,
        };
      default:
        return {
          'text': status,
          'color': Colors.grey,
        };
    }
  }

  bool _matchesFilter(String status, int filterIndex) {
    switch (filterIndex) {
      case 0: // PENDENTES
        return status.toUpperCase() == 'PENDENTE' || status.toUpperCase() == 'SERVICO_EXTERNO';
      case 1: // EM MANUTENÇÃO
        return status.toUpperCase() == 'EM_MANUTENCAO';
      case 2: // APROVADOS
        return status.toUpperCase() == 'FINALIZADO';
      default:
        return false;
    }
  }

  Future<void> _loadOrcamentos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final orcamentos = await _repository.findAll(page: 1, limit: 100);
      setState(() {
        _orcamentos = orcamentos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar orçamentos: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<OrcamentoModel> get _filteredOrcamentos {
    return _orcamentos
        .where((orcamento) => _matchesFilter(orcamento.status, _selectedTabIndex))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'SERVIÇOS',
        showBackButton: false,
      ),
      body: Column(
        children: [
 
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _tabs.asMap().entries.map((entry) {
                int index = entry.key;
                String tab = entry.value;
                bool isSelected = _selectedTabIndex == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Services List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadOrcamentos,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      )
                    : _filteredOrcamentos.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum orçamento encontrado',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadOrcamentos,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: _filteredOrcamentos.length,
                              itemBuilder: (context, index) {
                                final orcamento = _filteredOrcamentos[index];
                                final statusMap =
                                    _mapStatusToDisplay(orcamento.status);
                                
                    
                                final pecas = orcamento.orcamentoItems
                                    .where((item) =>
                                        item.tipoOrcamento.toUpperCase() ==
                                        'PECA')
                                    .toList();
                                final servicos = orcamento.orcamentoItems
                                    .where((item) =>
                                        item.tipoOrcamento.toUpperCase() ==
                                        'SERVICO')
                                    .toList();

                                return ServiceCard(
                                  id: orcamento.id?.toString() ?? 'N/A',
                                  title: orcamento.modelo,
                                  subtitle: orcamento.cliente?.nome ??
                                      'Cliente não informado',
                                  phone: orcamento.cliente?.telefone ?? 'N/A',
                                  status: statusMap['text'] as String,
                                  statusColor: statusMap['color'] as Color,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceDetailsScreen(
                                          id: orcamento.id?.toString() ?? 'N/A',
                                          title: orcamento.modelo,
                                          clientName: orcamento.cliente?.nome ??
                                              'Cliente não informado',
                                          phone: orcamento.cliente?.telefone ??
                                              'N/A',
                                          status: statusMap['text'] as String,
                                          statusColor:
                                              statusMap['color'] as Color,
                                          pecas: pecas,
                                          servicos: servicos,
                                        ),
                                      ),
                                    );
                                    
                                    if (result == true) {
                                      _loadOrcamentos();
                                    }
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BudgetScreen()),
          );
          
          if (mounted) {
            _loadOrcamentos();
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
          

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }
          
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GanhosScreen()),
            );
          }

          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MeusDadosScreen()),
            );
          }
        },
      ),
    );
  }
}