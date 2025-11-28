import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/rounded_text_field.dart';
import '../../../../core/widgets/cpf_modal.dart';
import '../../../../core/theme/colors.dart';
import '../../../orcamentos/model/cliente.dart';
import '../../../orcamentos/model/cliente_api.dart';
import '../../../orcamentos/model/create_orcamento_request.dart';
import '../../../orcamentos/model/repository/orcamento_repository_impl.dart';
import '../widgets/part_item_card.dart';
import '../../../services/presentation/screens/home_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({
    super.key,
    this.initialCpf,
  });

  final String? initialCpf;

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _cpfDisplayController = TextEditingController();
  final TextEditingController _totalPartsController = TextEditingController();
  final TextEditingController _totalServicesController = TextEditingController();
  final TextEditingController _grandTotalController = TextEditingController();

  String _selectedServiceType = 'DADOS';
  String? _clienteCpf;
  int? _clienteId;
  bool _isFetchingCliente = false;
  bool _isSaving = false;
  bool _isSendingWhatsApp = false;
  ClienteModel? _clienteLoaded;

  final ClienteApi _clienteApi = ClienteApi();
  final MaskTextInputFormatter _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final MaskTextInputFormatter _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  
  final List<Map<String, TextEditingController>> _partsList = [];
  final List<Map<String, TextEditingController>> _serviceList = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCpf != null) {
      _clienteCpf = widget.initialCpf!.replaceAll(RegExp(r'[^0-9]'), '');
      _cpfDisplayController.text = _cpfMask.maskText(_clienteCpf!);
    }

    if (_partsList.isEmpty) {
      _addPart(force: true);
    }

    if (_serviceList.isEmpty) {
      _addService(force: true);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCpfModal(initialCall: true);
    });

    _calculateTotal();
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _phoneController.dispose();
    _vehicleModelController.dispose();
    _plateController.dispose();
    _cpfDisplayController.dispose();
    _totalPartsController.dispose();
    _totalServicesController.dispose();
    _grandTotalController.dispose();
    
    for (var part in _partsList) {
      part['name']?.dispose();
      part['value']?.dispose();
    }
    for (var service in _serviceList) {
      service['name']?.dispose();
      service['value']?.dispose();
    }
    
    super.dispose();
  }

  void _addPart({bool force = false}) {
    if (!force && _partsList.isNotEmpty) {
      final lastPart = _partsList.last;
      final name = lastPart['name']?.text.trim() ?? '';
      final value = lastPart['value']?.text.trim() ?? '';
      if (name.isEmpty || value.isEmpty) {
        _showValidationError(
          'Preencha o nome e o valor da peça antes de adicionar outra.',
        );
        return;
      }
    }
    _partsList.add({
      'name': TextEditingController(),
      'value': TextEditingController(),
    });
    setState(() {});
    _calculateTotal();
  }

  void _addService({bool force = false}) {
    if (!force && _serviceList.isNotEmpty) {
      final lastService = _serviceList.last;
      final name = lastService['name']?.text.trim() ?? '';
      final value = lastService['value']?.text.trim() ?? '';
      if (name.isEmpty || value.isEmpty) {
        _showValidationError(
          'Preencha descrição e valor do serviço antes de adicionar outro.',
        );
        return;
      }
    }
    _serviceList.add({
      'name': TextEditingController(),
      'value': TextEditingController(),
    });
    setState(() {});
    _calculateTotal();
  }

  void _removePart(int index) {
    _partsList[index]['name']?.dispose();
    _partsList[index]['value']?.dispose();
    _partsList.removeAt(index);
    setState(() {});
    _calculateTotal();
  }

  void _removeService(int index) {
    _serviceList[index]['name']?.dispose();
    _serviceList[index]['value']?.dispose();
    _serviceList.removeAt(index);
    setState(() {});
    _calculateTotal();
  }

  void _calculateTotal() {
    double totalPartsValue = 0.0;
    
    for (var part in _partsList) {
      String valueText = part['value']?.text ?? '';
      double partValue = double.tryParse(valueText.replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0;
      totalPartsValue += partValue;
    }
    
    double totalServicesValue = 0.0;
    for (var service in _serviceList) {
      final valueText = service['value']?.text ?? '';
      final serviceValue = double.tryParse(
            valueText.replaceAll('R\$', '').replaceAll(',', '.'),
          ) ??
          0.0;
      totalServicesValue += serviceValue;
    }

    double total = totalPartsValue + totalServicesValue;
    _totalPartsController.text =
        'R\$ ${totalPartsValue.toStringAsFixed(2).replaceAll('.', ',')}';
    _totalServicesController.text =
        'R\$ ${totalServicesValue.toStringAsFixed(2).replaceAll('.', ',')}';
    _grandTotalController.text =
        'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  Future<void> _showCpfModal({bool initialCall = false}) async {
    final result = await CpfModal.show(
      context,
      initialCpf: _clienteCpf,
      barrierDismissible: !initialCall,
    );

    if (!mounted) return;

    if (result == null || result == 'CANCELLED') {
      _navigateToHome();
      return;
    }

    setState(() {
      _clienteCpf = result;
      _cpfDisplayController.text = _cpfMask.maskText(result);
    });

    await _fetchCliente(result);
  }

  bool _validateDadosTab() {
    final missingFields = <String>[];

    final cpfDigits =
        _cpfDisplayController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpfDigits.length != 11) {
      missingFields.add('CPF válido');
    } else {
      _clienteCpf = cpfDigits;
    }

    if (_clientNameController.text.trim().isEmpty) {
      missingFields.add('Nome do Cliente');
    }

    if (_phoneController.text.trim().isEmpty) {
      missingFields.add('Telefone');
    }

    if (_vehicleModelController.text.trim().isEmpty) {
      missingFields.add('Modelo do Veículo');
    }

    if (_plateController.text.trim().isEmpty) {
      missingFields.add('Placa');
    }

    if (missingFields.isNotEmpty) {
      _showValidationError(
        'Preencha: ${missingFields.join(', ')}.',
      );
      return false;
    }

    return true;
  }

  bool _validatePecasTab() {
    if (_partsList.isEmpty) {
      _showValidationError('Adicione pelo menos um item na aba Peças.');
      return false;
    }

    for (var i = 0; i < _partsList.length; i++) {
      final part = _partsList[i];
      final name = part['name']?.text.trim() ?? '';
      final valueText = part['value']?.text.trim() ?? '';
      if (name.isEmpty || valueText.isEmpty) {
        _showValidationError(
          'Preencha nome e valor de todos os itens (item ${i + 1}).',
        );
        return false;
      }
    }

    return true;
  }

  bool _validateServicosTab() {
    if (_serviceList.isEmpty) {
      _showValidationError('Adicione pelo menos um serviço.');
      return false;
    }

    for (var i = 0; i < _serviceList.length; i++) {
      final service = _serviceList[i];
      final name = service['name']?.text.trim() ?? '';
      final valueText = service['value']?.text.trim() ?? '';

      if (name.isEmpty || valueText.isEmpty) {
        _showValidationError(
          'Preencha descrição e valor de todos os serviços (serviço ${i + 1}).',
        );
        return false;
      }
    }

    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  void _handleNextStep() {
    if (_selectedServiceType == 'DADOS') {
      if (!_validateDadosTab()) return;
      setState(() {
        _selectedServiceType = 'PEÇAS';
      });
      return;
    }

    if (_selectedServiceType == 'PEÇAS') {
      if (!_validatePecasTab()) return;
      setState(() {
        _selectedServiceType = 'SERVIÇOS';
      });
      return;
    }

    if (_selectedServiceType == 'SERVIÇOS') {
      if (!_validateServicosTab()) return;
      _saveBudget();
    }
  }

  Future<void> _saveBudget() async {
    if (_isSaving) return;

    final placa = _plateController.text.trim().toUpperCase();
    final modelo = _vehicleModelController.text.trim();

    if (placa.isEmpty || modelo.isEmpty) {
      _showValidationError(
        'Informe modelo e placa do veículo antes de salvar.',
      );
      return;
    }

    final itens = <CreateOrcamentoItemRequest>[];

    for (final part in _partsList) {
      final descricao = part['name']!.text.trim();
      final valorText = part['value']!.text.trim();
      final valor = _parseToDouble(valorText);

      itens.add(
        CreateOrcamentoItemRequest(
          descricao: descricao,
          tipoOrcamento: 'PECA',
          valor: valor,
        ),
      );
    }

    for (final service in _serviceList) {
      final descricao = service['name']!.text.trim();
      final valorText = service['value']!.text.trim();
      final valor = _parseToDouble(valorText);

      itens.add(
        CreateOrcamentoItemRequest(
          descricao: descricao,
          tipoOrcamento: 'SERVICO',
          valor: valor,
        ),
      );
    }

    int clienteId;
    try {
      clienteId = await _ensureCliente();
    } catch (e) {
      _showValidationError(e.toString().replaceFirst('Exception: ', ''));
      setState(() {
        _isSaving = false;
      });
      return;
    }

    final request = CreateOrcamentoRequest(
      orcamento: OrcamentoData(
        clienteId: clienteId,
        placa: placa,
        modelo: modelo,
      ),
      orcamentoItens: OrcamentoItensWrapper(
        orcamentoItens: itens,
      ),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = OrcamentoRepositoryImpl();
      final created = await repository.createOrcamento(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Orçamento salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, created);
    } catch (e) {
      if (!mounted) return;
      _showValidationError(
        'Falha ao salvar orçamento: ${_friendlyError(e)}',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  double _parseToDouble(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9,.-]'), '');
    final normalized = cleaned.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  Future<int> _ensureCliente() async {
    if (_clienteId != null) {
      return _clienteId!;
    }

    final cpfDigits = _clienteCpf;
    final nome = _clientNameController.text.trim();
    final telefoneMasked = _phoneController.text.trim();
    final telefone = telefoneMasked.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpfDigits == null || cpfDigits.length != 11) {
      throw Exception('CPF inválido para criar o cliente.');
    }
    if (nome.isEmpty) {
      throw Exception('Informe o nome do cliente.');
    }
    if (telefone.isEmpty) {
      throw Exception('Informe o telefone do cliente.');
    }

    final cliente = await _clienteApi.createCliente(
      nome: nome,
      cpf: cpfDigits,
      telefone: telefone,
    );

    setState(() {
      _clienteId = cliente.id;
      _clienteLoaded = cliente;
    });

    if (cliente.id == null) {
      throw Exception('Não foi possível obter o ID do cliente criado.');
    }

    return cliente.id!;
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('returned status code 401')) {
      return 'Sessão expirada. Faça login novamente.';
    }
    if (message.contains('403')) {
      return 'Acesso negado.';
    }
    if (message.contains('Failed host lookup') ||
        message.contains('Connection refused')) {
      return 'Não foi possível conectar ao servidor.';
    }
    return message.replaceFirst('Exception: ', '');
  }

  Future<void> _sendBudgetViaWhatsApp() async {
    // Valida se todos os dados necessários estão preenchidos
    if (!_validateDadosTab()) {
      _showValidationError('Preencha todos os dados antes de enviar.');
      return;
    }

    if (!_validatePecasTab()) {
      _showValidationError('Adicione pelo menos uma peça antes de enviar.');
      return;
    }

    if (!_validateServicosTab()) {
      _showValidationError('Adicione pelo menos um serviço antes de enviar.');
      return;
    }

    // Valida telefone
    final telefone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (telefone.isEmpty || telefone.length < 10) {
      _showValidationError('Telefone inválido. Verifique o número do cliente.');
      return;
    }

    setState(() {
      _isSendingWhatsApp = true;
    });

    try {
      // Monta a mensagem
      final mensagem = _buildWhatsAppMessage();

      // Codifica a mensagem para URL
      final encodedMessage = Uri.encodeComponent(mensagem);

      // Monta a URL do WhatsApp
      final whatsappUrl = 'https://wa.me/55$telefone?text=$encodedMessage';

      // Tenta abrir o WhatsApp
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WhatsApp aberto com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Não foi possível abrir o WhatsApp');
      }
    } catch (e) {
      if (!mounted) return;
      _showValidationError('Erro ao abrir WhatsApp: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isSendingWhatsApp = false;
        });
      }
    }
  }

  String _buildWhatsAppMessage() {
    final clienteNome = _clientNameController.text.trim();
    final veiculo = _vehicleModelController.text.trim();
    final placa = _plateController.text.trim().toUpperCase();
    
    final buffer = StringBuffer();
    
    // Cabeçalho
    buffer.writeln('🚗 *AUTOSMART - ORÇAMENTO*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    
    // Dados do cliente
    buffer.writeln('👤 *Cliente:* $clienteNome');
    buffer.writeln('🚙 *Veículo:* $veiculo');
    buffer.writeln('🔖 *Placa:* $placa');
    buffer.writeln();
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    
    // Peças
    if (_partsList.isNotEmpty) {
      buffer.writeln('🔧 *PEÇAS:*');
      buffer.writeln();
      for (var i = 0; i < _partsList.length; i++) {
        final part = _partsList[i];
        final nome = part['name']!.text.trim();
        final valor = part['value']!.text.trim();
        buffer.writeln('${i + 1}. $nome');
        buffer.writeln('   💰 $valor');
        if (i < _partsList.length - 1) buffer.writeln();
      }
      buffer.writeln();
      buffer.writeln('*Subtotal Peças:* ${_totalPartsController.text}');
      buffer.writeln();
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln();
    }
    
    // Serviços
    if (_serviceList.isNotEmpty) {
      buffer.writeln('⚙️ *SERVIÇOS:*');
      buffer.writeln();
      for (var i = 0; i < _serviceList.length; i++) {
        final service = _serviceList[i];
        final nome = service['name']!.text.trim();
        final valor = service['value']!.text.trim();
        buffer.writeln('${i + 1}. $nome');
        buffer.writeln('   💰 $valor');
        if (i < _serviceList.length - 1) buffer.writeln();
      }
      buffer.writeln();
      buffer.writeln('*Subtotal Serviços:* ${_totalServicesController.text}');
      buffer.writeln();
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln();
    }
    
    // Total geral
    buffer.writeln('💵 *TOTAL DO ORÇAMENTO:* ${_grandTotalController.text}');
    buffer.writeln();
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    buffer.writeln('📅 *Validade:* 7 dias');
    buffer.writeln();
    buffer.writeln('_Orçamento gerado pelo sistema AUTOSMART_');
    
    return buffer.toString();
  }

  Future<void> _fetchCliente(String cpfDigits) async {
    setState(() {
      _isFetchingCliente = true;
    });

    try {
      final cliente = await _clienteApi.findByCpf(cpfDigits);
      if (!mounted) return;

      if (cliente == null) {
        setState(() {
          _clienteId = null;
          _clienteLoaded = null;
          _clientNameController.clear();
          _phoneController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cliente não encontrado. Preencha os dados manualmente.',
            ),
          ),
        );
        return;
      }

      setState(() {
        _clienteId = cliente.id;
        _clienteLoaded = cliente;
        _clientNameController.text = cliente.nome;
        _phoneController.text = _phoneMask.maskText(cliente.telefone);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar cliente: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingCliente = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'ORÇAMENTO',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServiceType = 'DADOS';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedServiceType == 'DADOS' ? Colors.grey[700] : Colors.transparent,
                      ),
                      child: const Text(
                        'DADOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServiceType = 'PEÇAS';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedServiceType == 'PEÇAS' ? Colors.grey[700] : Colors.transparent,
                      ),
                      child: const Text(
                        'PEÇAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServiceType = 'SERVIÇOS';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedServiceType == 'SERVIÇOS' ? Colors.grey[700] : Colors.transparent,
                      ),
                      child: const Text(
                        'SERVIÇOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_isFetchingCliente)
                    const LinearProgressIndicator(
                      minHeight: 2,
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          if (_selectedServiceType == 'DADOS') ...[
                            RoundedTextField(
                              label: 'CPF do Cliente',
                              controller: _cpfDisplayController,
                              inputFormatters: [_cpfMask],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final digits =
                                    value.replaceAll(RegExp(r'[^0-9]'), '');
                                _clienteCpf = digits.length == 11 ? digits : null;
                              },
                            ),
                            const SizedBox(height: 12),
                            RoundedTextField(
                              label: 'Nome do Cliente',
                              controller: _clientNameController,
                            ),
                            const SizedBox(height: 20),
                            RoundedTextField(
                              label: 'Telefone',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [_phoneMask],
                            ),
                            const SizedBox(height: 20),
                            RoundedTextField(
                              label: 'Modelo do Veículo',
                              controller: _vehicleModelController,
                            ),
                            const SizedBox(height: 20),
                            RoundedTextField(
                              label: 'Placa',
                              controller: _plateController,
                            ),
                          ] else if (_selectedServiceType == 'PEÇAS') ...[
                            ..._partsList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, TextEditingController> part = entry.value;
                              
                              return PartItemCard(
                                index: index,
                                nameController: part['name']!,
                                valueController: part['value']!,
                                onRemove: () => _removePart(index),
                                canRemove: _partsList.length > 1,
                                onValueChanged: (value) => _calculateTotal(),
                              );
                            }).toList(),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton.icon(
                                onPressed: () => _addPart(),
                                icon: const Icon(Icons.add, color: AppColors.white),
                                label: const Text(
                                  'Adicionar Item',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ] else if (_selectedServiceType == 'SERVIÇOS') ...[
                            ..._serviceList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final service = entry.value;
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[200]!),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: AppColors.primary,
                                              child: Text(
                                                '${index + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Informações do serviço',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (_serviceList.length > 1)
                                              IconButton(
                                                onPressed: () => _removeService(index),
                                                icon: const Icon(Icons.delete_outline),
                                                color: Colors.redAccent,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        RoundedTextField(
                                          label: 'Descrição do serviço',
                                          controller: service['name'],
                                          onChanged: (_) => setState(() {}),
                                        ),
                                        const SizedBox(height: 12),
                                        RoundedTextField(
                                          label: 'Valor do Serviço',
                                          controller: service['value'],
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  decimal: true),
                                          onChanged: (_) => _calculateTotal(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton.icon(
                                onPressed: () => _addService(),
                                icon: const Icon(Icons.add, color: AppColors.white),
                                label: const Text(
                                  'Adicionar Serviço',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  if (_selectedServiceType == 'PEÇAS')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: RoundedTextField(
                              label: 'Total de Peças',
                              controller: _totalPartsController,
                              enabled: false,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  if (_selectedServiceType == 'SERVIÇOS')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: RoundedTextField(
                                        label: 'Total de Serviços',
                                        controller: _totalServicesController,
                                        enabled: false,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 56,
                                      child: const Text(
                                        '+',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: RoundedTextField(
                                        label: 'Total de Peças',
                                        controller: _totalPartsController,
                                        enabled: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _grandTotalController,
                                  enabled: false,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Total do Orçamento',
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    filled: true,
                                    fillColor: Colors.green[50],
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  // Botão Enviar via WhatsApp (apenas na aba SERVIÇOS)
                  if (_selectedServiceType == 'SERVIÇOS') ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSendingWhatsApp ? null : _sendBudgetViaWhatsApp,
                        icon: _isSendingWhatsApp
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.chat, color: Colors.white),
                        label: Text(
                          _isSendingWhatsApp ? 'Enviando...' : 'Enviar Orçamento via WhatsApp',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366), // Cor oficial do WhatsApp
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleNextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _selectedServiceType == 'SERVIÇOS'
                                  ? 'Salvar'
                                  : 'Próximo',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
