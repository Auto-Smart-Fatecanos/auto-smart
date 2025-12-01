import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../core/theme/colors.dart';
import '../../../services/presentation/screens/home_screen.dart';
import '../../../profile/presentation/screens/meus_dados_screen.dart';
import '../../../earnings/presentation/screens/ganhos_screen.dart';
import '../../../orcamentos/model/repository/orcamento_repository_impl.dart';
import '../../../orcamentos/model/orcamento_model.dart';
import '../widgets/vehicle_search_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedBottomIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  final OrcamentoRepositoryImpl _repository = OrcamentoRepositoryImpl();

  List<OrcamentoModel> _orcamentos = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAllOrcamentos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllOrcamentos() async {
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
        _error = 'Erro ao carregar orçamentos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchByPlaca(String query) async {
    final trimmedQuery = query.trim();
    
    // Se a query for igual à última, não busca novamente
    if (trimmedQuery == _lastQuery) return;
    _lastQuery = trimmedQuery;

    // Se a query estiver vazia, carrega todos
    if (trimmedQuery.isEmpty) {
      await _loadAllOrcamentos();
      return;
    }

    // Se a query tiver menos de 2 caracteres, não busca
    if (trimmedQuery.length < 2) return;

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      // Usa a rota do backend para buscar por placa
      final orcamentos = await _repository.searchByPlaca(trimmedQuery);
      if (mounted && _lastQuery == trimmedQuery) {
        setState(() {
          _orcamentos = orcamentos;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted && _lastQuery == trimmedQuery) {
        setState(() {
          _error = 'Erro ao buscar: $e';
          _isSearching = false;
        });
      }
    }
  }

  double _calcularTotalOrcamento(OrcamentoModel orcamento) {
    double total = 0.0;
    for (final item in orcamento.orcamentoItems) {
      if (item.ativo) {
        total += item.valor;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'PESQUISAR',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Header com SearchBar
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por placa...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        )
                      : Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade600,
                        ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _searchByPlaca('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {
                setState(() {}); // Atualiza o ícone de limpar
                _searchByPlaca(value);
              },
            ),
          ),

          // Título da seção
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Orçamentos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_orcamentos.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de orçamentos
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
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const GanhosScreen()),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Carregando orçamentos...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Erro ao carregar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadAllOrcamentos,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_orcamentos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 56,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchController.text.isEmpty
                  ? 'Nenhum orçamento cadastrado'
                  : 'Nenhum resultado para "${_searchController.text}"',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Os orçamentos aparecerão aqui'
                  : 'Tente buscar por outra placa',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (_searchController.text.isEmpty) {
          await _loadAllOrcamentos();
        } else {
          _lastQuery = ''; // Força nova busca
          await _searchByPlaca(_searchController.text);
        }
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _orcamentos.length,
        itemBuilder: (context, index) {
          final orcamento = _orcamentos[index];
          final total = _calcularTotalOrcamento(orcamento);
          final clienteNome = orcamento.cliente?.nome ?? 'Cliente não informado';

          return VehicleSearchCard(
            plate: orcamento.placa,
            model: orcamento.modelo,
            owner: clienteNome,
            totalValue: 'R\$ ${total.toStringAsFixed(2)}',
          );
        },
      ),
    );
  }
}
