import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../services/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _cpfFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final AuthService _authService = AuthService();
  final MaskTextInputFormatter _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'\d')},
  );
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  AnimationController? _shakeController;
  Animation<double>? _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _setupShakeAnimation();
    _loadRememberMe();
    
    // Auto-focus no CPF após build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cpfFocus.requestFocus();
    });
  }

  void _setupShakeAnimation() {
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_shakeController!);
  }

  Future<void> _loadRememberMe() async {
    // Carregar CPF salvo se "lembrar-me" estava ativo
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCpf = prefs.getString('saved_cpf');
      final rememberMe = prefs.getBool('remember_me') ?? false;
      
      if (rememberMe && savedCpf != null) {
        final maskedCpf = _cpfFormatter.maskText(savedCpf);
        setState(() {
          _cpfController.text = maskedCpf;
          _cpfController.selection =
              TextSelection.collapsed(offset: maskedCpf.length);
          _rememberMe = true;
        });
        _cpfFormatter.formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: maskedCpf),
        );
      }
    } catch (e) {
      // Silenciosamente falha se SharedPreferences não estiver disponível
    }
  }

  Future<void> _saveRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_cpf', _cpfFormatter.getUnmaskedText());
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('saved_cpf');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      // Silenciosamente falha
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    _cpfFocus.dispose();
    _passwordFocus.dispose();
    _shakeController?.dispose();
    super.dispose();
  }

  String? _validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu CPF';
    }
    final numericCpf = value.replaceAll(RegExp(r'\D'), '');
    if (numericCpf.length != 11) {
      return 'O CPF deve conter 11 dígitos';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _triggerShakeAnimation() {
    _shakeController?.forward(from: 0);
  }

  Future<void> _handleLogin() async {
    // Validar form
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      _triggerShakeAnimation();
      return;
    }

    // Fechar teclado
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
    final success = await _authService.login(
      _cpfFormatter.getUnmaskedText(),
      _passwordController.text,
    );

      if (!mounted) return;

    if (success) {
        // Salvar "lembrar-me"
        await _saveRememberMe();
        
        // Feedback de sucesso
        HapticFeedback.lightImpact();
        _showSuccessSnackBar('Login realizado com sucesso!');
        
        // Aguardar um pouco para mostrar o feedback
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!mounted) return;
        
        // Navegar com transição suave
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              
              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
      );
    } else {
        // Erro de autenticação
        HapticFeedback.heavyImpact();
        _triggerShakeAnimation();
        _showErrorSnackBar('CPF ou senha incorretos');
      }
    } catch (e) {
      if (!mounted) return;
      
      HapticFeedback.heavyImpact();
      _triggerShakeAnimation();
      
      // Tratamento específico de erros
      String errorMessage = 'Erro ao fazer login';
      
      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException')) {
        errorMessage = 'Sem conexão com a internet';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tempo de conexão esgotado';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Erro ao processar resposta do servidor';
      }
      
      _showErrorSnackBar(errorMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final emailController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.lock_reset, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(
              'Recuperar Senha',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digite seu email para receber instruções de recuperação de senha.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'seu@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                _showErrorSnackBar('Por favor, digite um email válido');
                return;
              }
              
              Navigator.pop(context);
              _showSuccessSnackBar('Instruções enviadas para ${emailController.text}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obter dimensões da tela para responsividade
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Padding responsivo: 8% da largura, mas entre 24px e 60px
    final horizontalPadding = (screenWidth * 0.08).clamp(24.0, 60.0);
    
    // Tamanho da logo padronizado: 38% da largura, entre 180px e 280px
    // Tamanho ideal para tela de login profissional
    final logoSize = (screenWidth * 0.38).clamp(180.0, 280.0);
    
    // Padding vertical para melhor distribuição
    final verticalPadding = screenHeight * 0.04;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image com fallback color
          Container(
        decoration: BoxDecoration(
          // Fallback: gradiente escuro suave
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A1A),
              AppColors.primary,
            ],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
          ),
          
          // Overlay escuro sutil para melhorar contraste e legibilidade
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: AnimatedBuilder(
                    animation: _shakeAnimation ?? const AlwaysStoppedAnimation(0),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation?.value ?? 0, 0),
                        child: child,
                      );
                    },
                    child: Form(
                      key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                          // Logo com tamanho padronizado
                          Hero(
                            tag: 'logo',
                            child: Image.asset(
                      'assets/images/logo.png',
                      width: logoSize,
                      height: logoSize,
                            ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Espaçamento balanceado entre logo e campos
                    
        // CPF field com acessibilidade
                          Semantics(
                            label: 'Campo de CPF',
                            hint: 'Digite seu CPF para fazer login',
                            textField: true,
                            child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _cpfController,
                              focusNode: _cpfFocus,
                      keyboardType: TextInputType.number,
                              inputFormatters: [_cpfFormatter],
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                      style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'CPF',
                        hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: Colors.grey[700],
                                  size: 22,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                            width: 2,
                          ),
                        ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  height: 0.8,
                                ),
                              ),
                              validator: _validateCpf,
                              onFieldSubmitted: (_) {
                                _passwordFocus.requestFocus();
                              },
                            ),
                          ),
                          ),
                          const SizedBox(height: 20),
                    
                    // Password field com acessibilidade
                          Semantics(
                            label: 'Campo de senha',
                            hint: 'Digite sua senha',
                            obscured: true,
                            textField: true,
                            child:
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                      controller: _passwordController,
                              focusNode: _passwordFocus,
                      obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              enabled: !_isLoading,
                      style: const TextStyle(
                        fontSize: 16,
                                color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Senha',
                        hintStyle: TextStyle(
                                  color: Colors.grey[600],
                          fontSize: 16,
                        ),
                                prefixIcon: Icon(
                                  Icons.lock_outlined,
                                  color: Colors.grey[700],
                                  size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                                    _obscurePassword 
                                      ? Icons.visibility_outlined 
                                      : Icons.visibility_off_outlined,
                                    color: Colors.grey[700],
                                    size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                errorStyle: const TextStyle(
                                  fontSize: 12,
                                  height: 0.8,
                                ),
                              ),
                              validator: _validatePassword,
                              onFieldSubmitted: (_) {
                                _handleLogin();
                              },
                            ),
                          ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Lembrar-me e Esqueci senha
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Checkbox Lembrar-me
                              Expanded(
                                child: InkWell(
                                  onTap: _isLoading ? null : () {
                                    setState(() {
                                      _rememberMe = !_rememberMe;
                                    });
                                    HapticFeedback.selectionClick();
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: _isLoading ? null : (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                              HapticFeedback.selectionClick();
                                            },
                                            // Melhor contraste para acessibilidade
                                            activeColor: Colors.white,
                                            checkColor: AppColors.primary,
                                            side: BorderSide(
                                              color: Colors.white.withOpacity(0.9),
                                              width: 2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Lembrar-me',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Link Esqueci senha
                              TextButton(
                                onPressed: _isLoading ? null : _showForgotPasswordDialog,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Esqueci minha senha',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.025), // Espaçamento responsivo
                          
                          // Botão Entrar com acessibilidade
                          Semantics(
                            button: true,
                            label: 'Botão Entrar',
                            hint: 'Pressione para fazer login',
                            enabled: !_isLoading,
                            child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                              elevation: 4,
                              shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                        ),
                              disabledBackgroundColor: Colors.white.withOpacity(0.7),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                                    width: 24,
                                    height: 24,
                              child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                              ),
                            ),
                    ),
                          ),
                          
                          // Botão de teste - apenas em desenvolvimento
                          if (const bool.fromEnvironment('dart.vm.product') == false) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                              onPressed: _isLoading ? null : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.white,
                                  width: 1.5,
                                ),
                        foregroundColor: AppColors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                                'Entrar (modo teste)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          
                          // Espaçamento extra no final para balanço visual
                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
          // Loading overlay simplificado e menos intrusivo
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  elevation: 8,
                  margin: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicador circular com animação suave
                        const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Autenticando...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aguarde um momento',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
