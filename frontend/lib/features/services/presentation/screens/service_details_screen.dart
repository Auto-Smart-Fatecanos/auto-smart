import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/authenticated_image_widget.dart';
import '../../../../core/widgets/image_source_dialog.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/services/whatsapp_service.dart';
import '../../../checkin/presentation/screens/checkin_screen.dart';
import '../../../checkin/presentation/screens/checkout_screen.dart';
import '../../../checkin/presentation/screens/view_checklist_screen.dart';
import '../../../checkin/model/checklist_model.dart';
import '../../../checkin/model/repository/checklist_repository_impl.dart';
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
  final Map<int, TextEditingController> _pecaValueControllers = {};
  final Map<int, TextEditingController> _servicoValueControllers = {};
  final OrcamentoRepositoryImpl _repository = OrcamentoRepositoryImpl();
  final ChecklistRepositoryImpl _checklistRepository = ChecklistRepositoryImpl();
  final ImagePicker _picker = ImagePicker();
  List<ChecklistModel> _checklists = [];
  bool _isLoadingChecklists = false;
  String? _fotoVeiculo;
  XFile? _selectedFoto;
  Uint8List? _selectedFotoBytes;

  final Map<String, String> _statusMap = {
    'AGUARDANDO': 'AGUARDANDO',
    'EXECUTANDO': 'EXECUTANDO',
    'REPROVADO': 'REPROVADO',
    'FINALIZADO': 'FINALIZADO',
    'SERVICO_EXTERNO': 'SERVIÇO EXTERNO',
  };

  final Map<String, Color> _statusColorMap = {
    'AGUARDANDO': Colors.orange,
    'EXECUTANDO': Colors.blue,
    'REPROVADO': Colors.red,
    'FINALIZADO': Colors.green,
    'SERVICO_EXTERNO': Colors.purple,
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
    _initializeValueControllers();
    _loadOrcamentoData();
    _loadChecklists();
  }

  void _initializeValueControllers() {
    // Dispose existing controllers
    for (var controller in _pecaValueControllers.values) {
      controller.dispose();
    }
    for (var controller in _servicoValueControllers.values) {
      controller.dispose();
    }
    
    // Clear maps
    _pecaValueControllers.clear();
    _servicoValueControllers.clear();
    
    // Create new controllers
    for (int i = 0; i < _editedPecas.length; i++) {
      _pecaValueControllers[i] = TextEditingController(
        text: _editedPecas[i].valor.toStringAsFixed(2).replaceAll('.', ','),
      );
    }
    for (int i = 0; i < _editedServicos.length; i++) {
      _servicoValueControllers[i] = TextEditingController(
        text: _editedServicos[i].valor.toStringAsFixed(2).replaceAll('.', ','),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _pecaValueControllers.values) {
      controller.dispose();
    }
    for (var controller in _servicoValueControllers.values) {
      controller.dispose();
    }
    super.dispose();
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
          _fotoVeiculo = orcamento.fotoVeiculo;
          
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
            _initializeValueControllers();
          }
        });
      }
    } catch (e) {
      // Silently fail, keep using widget data
    }
  }

  Future<void> _loadChecklists() async {
    final orcamentoId = int.tryParse(widget.id);
    if (orcamentoId == null) return;

    setState(() {
      _isLoadingChecklists = true;
    });

    try {
      final checklists = await _checklistRepository.findByOrcamentoId(orcamentoId);
      if (mounted) {
        setState(() {
          _checklists = checklists;
          _isLoadingChecklists = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingChecklists = false;
        });
      }
      // Silently fail
    }
  }

  ChecklistModel? _getChecklistByTipo(String tipo) {
    try {
      return _checklists.firstWhere(
        (checklist) => checklist.tipo.toUpperCase() == tipo.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Data não disponível';
    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year;
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às $hour:$minute';
  }

  Duration? _calculateTotalTime() {
    final checkin = _getChecklistByTipo('CHECK_IN');
    final checkout = _getChecklistByTipo('CHECK_OUT');
    
    if (checkin?.dataCriacao == null || checkout?.dataCriacao == null) {
      return null;
    }

    final checkinLocal = checkin!.dataCriacao!.toLocal();
    final checkoutLocal = checkout!.dataCriacao!.toLocal();
    return checkoutLocal.difference(checkinLocal);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    return '${minutes}min';
  }

  Map<String, dynamic> _mapStatusToDisplay(String status) {
    switch (status.toUpperCase()) {
      case 'AGUARDANDO':
        return {
          'text': 'AGUARDANDO',
          'color': Colors.orange,
        };
      case 'EXECUTANDO':
        return {
          'text': 'EXECUTANDO',
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

  bool _canEditOrcamento() {
    final statusKey = _getStatusKey(_currentStatus);
    return statusKey != 'FINALIZADO' && statusKey != 'REPROVADO';
  }

  Future<void> _showEditConfirmationDialog() async {
    final result = await ConfirmationDialog.show(
      context,
      title: 'Editar Orçamento',
      message: 'Deseja alterar o status desse orçamento?',
      confirmText: 'Sim',
      cancelText: 'Não',
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

  void _updatePecaValue(int index, String value) {
    final cleanedValue = value.replaceAll(',', '.').replaceAll(RegExp(r'[^0-9.]'), '');
    final doubleValue = double.tryParse(cleanedValue) ?? 0.0;
    
    setState(() {
      _editedPecas = List.from(_editedPecas);
      _editedPecas[index] = _editedPecas[index].copyWith(valor: doubleValue);
    });
  }

  void _updateServicoValue(int index, String value) {
    final cleanedValue = value.replaceAll(',', '.').replaceAll(RegExp(r'[^0-9.]'), '');
    final doubleValue = double.tryParse(cleanedValue) ?? 0.0;
    
    setState(() {
      _editedServicos = List.from(_editedServicos);
      _editedServicos[index] = _editedServicos[index].copyWith(valor: doubleValue);
    });
  }

  Future<void> _deleteOrcamento() async {
    final result = await ConfirmationDialog.show(
      context,
      title: 'Excluir Orçamento',
      message: 'Tem certeza que deseja excluir o orçamento?',
      confirmText: 'Sim',
      cancelText: 'Não',
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

  Future<void> _showImageSourceDialog() async {
    return ImageSourceDialog.show(
      context,
      onSourceSelected: _pickFoto,
    );
  }

  Future<void> _pickFoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        Uint8List? bytes;
        if (kIsWeb) {
          bytes = await image.readAsBytes();
        }
        
        setState(() {
          _selectedFoto = image;
          _selectedFotoBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
      final statusChanged = statusKey != originalStatusKey;
      
      if (statusChanged) {
        await _repository.updateStatus(orcamentoId, statusKey);
      }

      if (_selectedFoto != null) {
        await _repository.updateFotoVeiculo(orcamentoId, _selectedFoto!);
      }

      await _loadOrcamentoData();

      if (mounted) {
        setState(() {
          _isEditing = false;
          _selectedFoto = null;
          _selectedFotoBytes = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Orçamento atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Se o status mudou, pergunta se quer notificar o cliente
        if (statusChanged && mounted) {
          await _askToNotifyClient(statusKey);
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
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

  Future<void> _askToNotifyClient(String newStatus) async {
    // Verifica se tem telefone válido
    final phone = widget.phone;
    if (phone.isEmpty || phone.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
      return; // Não mostra o diálogo se não tiver telefone válido
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.phone_android,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Notificar Cliente',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deseja enviar uma notificação via WhatsApp informando o cliente sobre a alteração de status?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, size: 20, color: Colors.grey.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.clientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Não',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.send_rounded, size: 20),
            label: const Text(
              'Enviar WhatsApp',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      // Extrai o modelo do título (formato: "PLACA - MODELO")
      final titleParts = widget.title.split(' - ');
      final plate = titleParts.isNotEmpty ? titleParts[0] : widget.title;
      final model = titleParts.length > 1 ? titleParts[1] : widget.title;

      await WhatsAppService.sendStatusChangeNotification(
        context: context,
        phone: phone,
        clientName: widget.clientName,
        vehicleModel: model,
        plate: plate,
        oldStatus: _currentStatus,
        newStatus: newStatus,
      );
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
                          GestureDetector(
                            onTap: _isEditing ? _showImageSourceDialog : null,
                            child: Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _selectedFoto != null
                                    ? (kIsWeb && _selectedFotoBytes != null
                                        ? Image.memory(
                                            _selectedFotoBytes!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: AppColors.secondary,
                                                child: const Icon(
                                                  Icons.directions_car,
                                                  color: AppColors.textSecondary,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                          )
                                        : Image.file(
                                            File(_selectedFoto!.path),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: AppColors.secondary,
                                                child: const Icon(
                                                  Icons.directions_car,
                                                  color: AppColors.textSecondary,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                          ))
                                    : _fotoVeiculo != null && _fotoVeiculo!.isNotEmpty
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              AuthenticatedImageWidget(
                                                path: _fotoVeiculo!,
                                                fit: BoxFit.cover,
                                                isOrcamento: true,
                                                errorWidget: Container(
                                                  color: AppColors.secondary,
                                                  child: const Icon(
                                                    Icons.directions_car,
                                                    color: AppColors.textSecondary,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                              if (_isEditing)
                                                Container(
                                                  color: Colors.black.withOpacity(0.3),
                                                  child: const Center(
                                                    child: Text(
                                                      'Adicionar foto',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )
                                        : Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Container(
                                                color: AppColors.secondary,
                                                child: const Icon(
                                                  Icons.directions_car,
                                                  color: AppColors.textSecondary,
                                                  size: 40,
                                                ),
                                              ),
                                              if (_isEditing)
                                                Container(
                                                  color: Colors.black.withOpacity(0.3),
                                                  child: const Center(
                                                    child: Text(
                                                      'Adicionar foto',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                              ),
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
                                              selectedItemBuilder: (BuildContext context) {
                                                return _statusMap.values.map((String status) {
                                                  return Text(
                                                    status,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                              dropdownColor: AppColors.white,
                                              items: _statusMap.values
                                                  .map((status) =>
                                                      DropdownMenuItem(
                                                        value: status,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                                          child: Text(
                                                            status,
                                                            style: const TextStyle(
                                                              color: AppColors.textPrimary,
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
                      if (!_isEditing && _canEditOrcamento())
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
                            if (_isEditing)
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _pecaValueControllers[index],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: peca.ativo
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                  decoration: InputDecoration(
                                    prefixText: 'R\$ ',
                                    prefixStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: peca.ativo
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: peca.ativo
                                            ? AppColors.primary
                                            : Colors.grey,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: peca.ativo
                                            ? AppColors.primary
                                            : Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    isDense: true,
                                  ),
                                  onChanged: (value) => _updatePecaValue(index, value),
                                ),
                              )
                            else
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
                            if (_isEditing)
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _servicoValueControllers[index],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: servico.ativo
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                  decoration: InputDecoration(
                                    prefixText: 'R\$ ',
                                    prefixStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: servico.ativo
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: servico.ativo
                                            ? AppColors.primary
                                            : Colors.grey,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: servico.ativo
                                            ? AppColors.primary
                                            : Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    isDense: true,
                                  ),
                                  onChanged: (value) => _updateServicoValue(index, value),
                                ),
                              )
                            else
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
                  
                  Builder(
                    builder: (context) {
                      final checkin = _getChecklistByTipo('CHECK_IN');
                      final hasCheckin = checkin != null;
                      final orcamentoId = int.tryParse(widget.id);

                      return InkWell(
                        onTap: hasCheckin || orcamentoId == null
                            ? null
                            : () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckinScreen(
                                      orcamentoId: orcamentoId,
                                      vehicleTitle: widget.title,
                                      clientName: widget.clientName,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  _loadChecklists();
                                  _loadOrcamentoData();
                                }
                              },
                        borderRadius: BorderRadius.circular(8),
                        child: Opacity(
                          opacity: hasCheckin ? 0.6 : 1.0,
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
                                  child: Icon(
                                    hasCheckin ? Icons.check_circle : Icons.login,
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
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              hasCheckin
                                                  ? _formatDate(checkin?.dataCriacao)
                                                  : 'Clique para fazer check-in',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: hasCheckin
                                                    ? AppColors.textPrimary
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                          if (hasCheckin)
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ViewChecklistScreen(
                                                      checklist: checkin!,
                                                      vehicleTitle: widget.title,
                                                      clientName: widget.clientName,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: const Text(
                                                'Ver',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (!hasCheckin)
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    height: 1,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Builder(
                    builder: (context) {
                      final checkin = _getChecklistByTipo('CHECK_IN');
                      final checkout = _getChecklistByTipo('CHECK_OUT');
                      final hasCheckin = checkin != null;
                      final hasCheckout = checkout != null;
                      final orcamentoId = int.tryParse(widget.id);
                      final canDoCheckout = hasCheckin && !hasCheckout && orcamentoId != null;

                      return InkWell(
                        onTap: !canDoCheckout
                            ? null
                            : () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      orcamentoId: orcamentoId,
                                      vehicleTitle: widget.title,
                                      clientName: widget.clientName,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  _loadChecklists();
                                  _loadOrcamentoData();
                                }
                              },
                        borderRadius: BorderRadius.circular(8),
                        child: Opacity(
                          opacity: hasCheckout ? 0.6 : 1.0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    hasCheckout ? Icons.check_circle : Icons.logout,
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
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              hasCheckout
                                                  ? _formatDate(checkout?.dataCriacao)
                                                  : !hasCheckin
                                                      ? 'Aguardando check-in'
                                                      : 'Clique para fazer check-out',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: hasCheckout || !hasCheckin
                                                    ? AppColors.textPrimary
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                          if (hasCheckout)
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ViewChecklistScreen(
                                                      checklist: checkout!,
                                                      vehicleTitle: widget.title,
                                                      clientName: widget.clientName,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: const Text(
                                                'Ver',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (canDoCheckout)
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  Builder(
                    builder: (context) {
                      final totalTime = _calculateTotalTime();
                      if (totalTime == null) return const SizedBox.shrink();

                      return Column(
                        children: [
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
                                  _formatDuration(totalTime),
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
