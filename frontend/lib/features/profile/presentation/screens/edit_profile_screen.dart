import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/theme/colors.dart';
import '../../data/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  final UserService _userService = UserService();

  final MaskTextInputFormatter _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'\d')},
  );

  bool _isLoading = false;
  bool _isLoadingData = true;
  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;

  // Dados do usuário logado
  int? _userId;
  String? _cpf;
  int? _storeId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _userService.getCurrentUser();
      if (userData != null && mounted) {
        // Aplicar máscara no telefone se tiver valor
        final phoneNumber = userData['phoneNumber'] ?? '';
        if (phoneNumber.isNotEmpty) {
          final maskedPhone = _telefoneFormatter.maskText(phoneNumber.replaceAll(RegExp(r'\D'), ''));
          _telefoneController.text = maskedPhone;
        }
        
        setState(() {
          _userId = userData['id'];
          _nomeController.text = userData['firstName'] ?? '';
          _sobrenomeController.text = userData['lastName'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _cpf = userData['cpf'];
          _storeId = userData['storeId'];
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        _showErrorSnackBar('Erro ao carregar dados: $e');
      }
    }
  }

  Future<void> _salvarDados() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_userId == null || _cpf == null || _storeId == null) {
      _showErrorSnackBar('Dados do usuário não encontrados. Faça login novamente.');
      return;
    }

    // Validar senhas se preenchidas
    if (_novaSenhaController.text.isNotEmpty) {
      if (_novaSenhaController.text != _confirmarSenhaController.text) {
        _showErrorSnackBar('As senhas não coincidem');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      await _userService.updateUser(
        userId: _userId!,
        firstName: _nomeController.text.trim(),
        lastName: _sobrenomeController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _telefoneFormatter.getUnmaskedText(),
        cpf: _cpf!,
        storeId: _storeId!,
        password: _novaSenhaController.text.isNotEmpty
            ? _novaSenhaController.text
            : null,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              const Text('Dados atualizados com sucesso!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Voltar para tela anterior
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erro ao salvar: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'EDITAR DADOS PESSOAIS',
        showBackButton: true,
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
                'PERFIL',
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
            child: _isLoadingData
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                  // Info do usuário
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              _nomeController.text.isNotEmpty
                                  ? _nomeController.text[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_nomeController.text} ${_sobrenomeController.text}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _emailController.text,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Seção: Informações Pessoais
                  _buildSectionTitle('Informações Pessoais'),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _nomeController,
                    label: 'Nome',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu nome';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _sobrenomeController,
                    label: 'Sobrenome',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu sobrenome';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu email';
                      }
                      if (!value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildPhoneField(),

                  const SizedBox(height: 32),

                  // Seção: Alterar Senha
                  _buildSectionTitle('Alterar Senha (Opcional)'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Deixe os campos de senha em branco para manter a senha atual',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildPasswordField(
                    controller: _novaSenhaController,
                    label: 'Nova Senha',
                    obscureText: _obscureNovaSenha,
                    onToggleVisibility: () {
                      setState(() => _obscureNovaSenha = !_obscureNovaSenha);
                    },
                    validator: (value) {
                      if (value != null && value.isNotEmpty && value.length < 6) {
                        return 'A senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildPasswordField(
                    controller: _confirmarSenhaController,
                    label: 'Confirmar Nova Senha',
                    obscureText: _obscureConfirmarSenha,
                    onToggleVisibility: () {
                      setState(
                          () => _obscureConfirmarSenha = !_obscureConfirmarSenha);
                    },
                    validator: (value) {
                      // Só valida se o campo "Nova Senha" foi preenchido
                      if (_novaSenhaController.text.isNotEmpty) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirme a nova senha';
                        }
                        if (value != _novaSenhaController.text) {
                          return 'As senhas não coincidem';
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _salvarDados,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_outlined, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Salvar Alterações',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: !_isLoading,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: !_isLoading,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[600],
            ),
            onPressed: onToggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _telefoneController,
        keyboardType: TextInputType.phone,
        enabled: !_isLoading,
        inputFormatters: [_telefoneFormatter],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, digite seu telefone';
          }
          final unmasked = _telefoneFormatter.getUnmaskedText();
          if (unmasked.length < 10) {
            return 'Telefone deve ter pelo menos 10 dígitos';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Telefone',
          hintText: '(00) 00000-0000',
          prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
