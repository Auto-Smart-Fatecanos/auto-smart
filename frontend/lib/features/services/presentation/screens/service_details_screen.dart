import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/theme/colors.dart';
import '../../../checkin/presentation/screens/checkin_screen.dart';
import '../../../orcamentos/model/orcamento_item_model.dart';
import '../../../orcamentos/model/repository/orcamento_repository_impl.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String id;
  final String title;
  final String clientName;
  final String phone;
  final String status;
  final Color statusColor;
  final List<OrcamentoItemModel> pecas;
  final List<OrcamentoItemModel> servicos;

  const ServiceDetailsScreen({
    super.key,
    required this.id,
    required this.title,
    required this.clientName,
    required this.phone,
    required this.status,
    required this.statusColor,
    required this.pecas,
    required this.servicos,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool _isEditing = false;
  bool _isSaving = false;
  String _selectedStatus = '';
  String _currentStatus = '';
  List<OrcamentoItemModel> _currentPecas = [];
  List<OrcamentoItemModel> _currentServicos = [];
  List<OrcamentoItemModel> _editedPecas = [];
  List<OrcamentoItemModel> _editedServicos = [];
  final OrcamentoRepositoryImpl _repository = OrcamentoRepositoryImpl();

  final Map<String, String> _statusMap = {
    'AGUARDANDO': 'PENDENTE',
    'EM_MANUTENCAO': 'EM MANUTENÇÃO',
    'REJEITADO': 'REPROVADO',
    'FINALIZADO': 'FINALIZADO',
    'CANCELADO': 'CANCELADO',
  };

  final Map<String, Color> _statusColorMap = {
    'AGUARDANDO': Colors.orange,
    'EM_MANUTENCAO': Colors.blue,
    'REJEITADO': Colors.red,
    'FINALIZADO': Colors.green,
    'CANCELADO': Colors.grey,
  };

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.status;
    _currentStatus = widget.status;
    _currentPecas = List.from(widget.pecas);
    _currentServicos = List.from(widget.servicos);
    _editedPecas = List.from(widget.pecas);
    _editedServicos = List.from(widget.servicos);
    _loadOrcamentoData();
  }

  Future<void> _loadOrcamentoData() async {
    try {
      final orcamentoId = int.tryParse(widget.id);
      if (orcamentoId == null) return;

      final orcamento = await _repository.findOne(orcamentoId);
      
      if (mounted) {
        setState(() {
          final statusMap = _mapStatusToDisplay(orcamento.status);
          _currentStatus = statusMap['text'] as String;
          
          final allItems = orcamento.orcamentoItems;
          _currentPecas = allItems
              .where((item) => item.tipoOrcamento.toUpperCase() == 'PECA')
              .toList();
          _currentServicos = allItems
              .where((item) => item.tipoOrcamento.toUpperCase() == 'SERVICO')
              .toList();
          
          if (!_isEditing) {
            _selectedStatus = _currentStatus;
            _editedPecas = List.from(_currentPecas);
            _editedServicos = List.from(_currentServicos);
          }
        });
      }
    } catch (e) {
      // Silently fail, keep using widget data
    }
  }

  Map<String, dynamic> _mapStatusToDisplay(String status) {
    switch (status.toUpperCase()) {
      case 'AGUARDANDO':
        return {
          'text': 'PENDENTE',
          'color': Colors.orange,
        };
      case 'EM_MANUTENCAO':
        return {
          'text': 'EM MANUTENÇÃO',
          'color': Colors.blue,
        };
      case 'REJEITADO':
        return {
          'text': 'REPROVADO',
          'color': Colors.red,
        };
      case 'FINALIZADO':
        return {
          'text': 'FINALIZADO',
          'color': Colors.green,
        };
      case 'CANCELADO':
        return {
          'text': 'CANCELADO',
          'color': Colors.grey,
        };
      default:
        return {
          'text': status,
          'color': Colors.grey,
        };
    }
  }

  String _getStatusKey(String displayStatus) {
    return _statusMap.entries
        .firstWhere((e) => e.value == displayStatus,
            orElse: () => MapEntry('AGUARDANDO', displayStatus))
        .key;
  }

  String _getDisplayStatus(String backendStatus) {
    return _statusMap[backendStatus.toUpperCase()] ?? backendStatus;
  }

  Color _getStatusColor(String status) {
    final key = _getStatusKey(status);
    return _statusColorMap[key] ?? Colors.grey;
  }

  Future<void> _showEditConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Orçamento'),
        content: const Text('Deseja alterar o status desse orçamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _toggleItemActive(List<OrcamentoItemModel> list, int index) {
    setState(() {
      if (list == _editedPecas) {
        _editedPecas = List.from(_editedPecas);
        _editedPecas[index] = _editedPecas[index].copyWith(
          ativo: !_editedPecas[index].ativo,
        );
      } else if (list == _editedServicos) {
        _editedServicos = List.from(_editedServicos);
        _editedServicos[index] = _editedServicos[index].copyWith(
          ativo: !_editedServicos[index].ativo,
        );
      }
    });
  }

  Future<void> _deleteOrcamento() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Orçamento'),
        content: const Text('Tem certeza que deseja excluir o orçamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result != true) return;

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final orcamentoId = int.tryParse(widget.id);
      if (orcamentoId == null) {
        throw Exception('ID do orçamento inválido');
      }

      await _repository.deleteOrcamento(orcamentoId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orçamento excluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final orcamentoId = int.tryParse(widget.id);
      if (orcamentoId == null) {
        throw Exception('ID do orçamento inválido');
      }

      final allItems = [..._editedPecas, ..._editedServicos]
          .where((item) => item.id != null)
          .toList();

      if (allItems.isNotEmpty) {
        await _repository.updateItens(orcamentoId, allItems);
      }

      final statusKey = _getStatusKey(_selectedStatus);
      final originalStatusKey = _getStatusKey(_currentStatus);
      if (statusKey != originalStatusKey) {
        await _repository.updateStatus(orcamentoId, statusKey);
      }

      await _loadOrcamentoData();

      if (mounted) {
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orçamento atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPecas = _isEditing
        ? _editedPecas
        : _currentPecas;
    final displayServicos = _isEditing
        ? _editedServicos
        : _currentServicos;

    final displayStatus = _isEditing ? _selectedStatus : _currentStatus;
    final statusColor = _isEditing
        ? _getStatusColor(_selectedStatus)
        : _getStatusColor(_currentStatus);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'DETALHES',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              color: AppColors.textSecondary,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _isEditing
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: DropdownButton<String>(
                                              value: _selectedStatus,
                                              underline: const SizedBox(),
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              isDense: true,
                                              isExpanded: false,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              dropdownColor: statusColor,
                                              items: _statusMap.values
                                                  .map((status) =>
                                                      DropdownMenuItem(
                                                        value: status,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                                          child: Text(
                                                            status,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _selectedStatus = value;
                                                  });
                                                }
                                              },
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              displayStatus,
                                              style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        widget.clientName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        widget.phone,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      '#${widget.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detalhes da manutenção',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (!_isEditing)
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: _showEditConfirmationDialog,
                          color: AppColors.textSecondary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (displayPecas.isNotEmpty) ...[
                    const Text(
                      'Peças:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...displayPecas.asMap().entries.map((entry) {
                      final index = entry.key;
                      final peca = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_isEditing)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _toggleItemActive(_editedPecas, index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            Expanded(
                              child: Text(
                                peca.descricao,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: peca.ativo
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  decoration: peca.ativo
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            Text(
                              'R\$ ${peca.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: peca.ativo
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                decoration: peca.ativo
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (displayServicos.isNotEmpty) const SizedBox(height: 16),
                  ],
                  
                  if (displayServicos.isNotEmpty) ...[
                    const Text(
                      'Serviços:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...displayServicos.asMap().entries.map((entry) {
                      final index = entry.key;
                      final servico = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_isEditing)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _toggleItemActive(_editedServicos, index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            Expanded(
                              child: Text(
                                servico.descricao,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: servico.ativo
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  decoration: servico.ativo
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            Text(
                              'R\$ ${servico.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: servico.ativo
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                decoration: servico.ativo
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  
                  if (displayPecas.isEmpty && displayServicos.isEmpty)
                    const Text(
                      'Nenhum item cadastrado',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  
                  if (displayPecas.isNotEmpty || displayServicos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'R\$ ${(displayPecas.where((p) => p.ativo).fold<double>(0, (sum, item) => sum + item.valor) + displayServicos.where((s) => s.ativo).fold<double>(0, (sum, item) => sum + item.valor)).toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  if (_isEditing) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _deleteOrcamento,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Excluir orçamento',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Controle de Entrada/Saída',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckinScreen(
                            vehicleTitle: widget.title,
                            clientName: widget.clientName,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.login,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Check-in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '15/12/2024 às 08:30',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    height: 1,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check-out',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              displayStatus == 'FINALIZADO' 
                                ? '15/12/2024 às 17:45' 
                                : 'Aguardando finalização',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: displayStatus == 'FINALIZADO' 
                                  ? AppColors.textPrimary 
                                  : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  if (displayStatus == 'FINALIZADO') ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tempo total: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '9h 15min',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
