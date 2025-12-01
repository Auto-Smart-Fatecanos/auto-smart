import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static const String _whatsAppBaseUrl = 'https://wa.me/55';

  /// Envia mensagem para o WhatsApp do cliente sobre alteração de status
  static Future<bool> sendStatusChangeNotification({
    required BuildContext context,
    required String phone,
    required String clientName,
    required String vehicleModel,
    required String plate,
    required String oldStatus,
    required String newStatus,
  }) async {
    final cleanPhone = _cleanPhoneNumber(phone);
    
    if (cleanPhone.isEmpty || cleanPhone.length < 10) {
      _showError(context, 'Número de telefone inválido');
      return false;
    }

    final message = _buildStatusChangeMessage(
      clientName: clientName,
      vehicleModel: vehicleModel,
      plate: plate,
      newStatus: newStatus,
    );

    return _openWhatsApp(context, cleanPhone, message);
  }

  /// Limpa o número de telefone, mantendo apenas dígitos
  static String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Constrói a mensagem de alteração de status
  static String _buildStatusChangeMessage({
    required String clientName,
    required String vehicleModel,
    required String plate,
    required String newStatus,
  }) {
    final statusInfo = _getStatusInfo(newStatus);
    
    return '''🚗 *AUTOSMART - ATUALIZAÇÃO DO SERVIÇO*
━━━━━━━━━━━━━━━━━━━━━

Olá, *$clientName*!

Temos uma atualização sobre o seu veículo:

🚙 *Veículo:* $vehicleModel
🔖 *Placa:* ${plate.toUpperCase()}

━━━━━━━━━━━━━━━━━━━━━

${statusInfo['emoji']} *Status:* ${statusInfo['text']}

${statusInfo['message']}

━━━━━━━━━━━━━━━━━━━━━

Em caso de dúvidas, estamos à disposição!

_Mensagem automática - AUTOSMART_''';
  }

  /// Retorna informações do status para a mensagem
  static Map<String, String> _getStatusInfo(String status) {
    switch (status.toUpperCase()) {
      case 'AGUARDANDO':
        return {
          'emoji': '⏳',
          'text': 'AGUARDANDO',
          'message': 'Seu veículo está na fila de espera e em breve iniciaremos os serviços.',
        };
      case 'EXECUTANDO':
        return {
          'emoji': '🔧',
          'text': 'EM EXECUÇÃO',
          'message': 'Os serviços no seu veículo já foram iniciados! Em breve você receberá mais atualizações.',
        };
      case 'SERVICO_EXTERNO':
      case 'SERVIÇO EXTERNO':
        return {
          'emoji': '🔄',
          'text': 'SERVIÇO EXTERNO',
          'message': 'Seu veículo foi encaminhado para um serviço especializado. Avisaremos assim que retornar.',
        };
      case 'FINALIZADO':
        return {
          'emoji': '✅',
          'text': 'FINALIZADO',
          'message': 'Seu veículo está pronto! Você já pode vir buscá-lo. Aguardamos você!',
        };
      case 'REPROVADO':
        return {
          'emoji': '❌',
          'text': 'REPROVADO',
          'message': 'O orçamento foi reprovado. Entre em contato conosco para mais informações.',
        };
      default:
        return {
          'emoji': '📋',
          'text': status,
          'message': 'O status do seu veículo foi atualizado.',
        };
    }
  }

  /// Abre o WhatsApp com a mensagem
  static Future<bool> _openWhatsApp(
    BuildContext context,
    String phone,
    String message,
  ) async {
    try {
      final encodedMessage = Uri.encodeComponent(message);
      final whatsappUrl = '$_whatsAppBaseUrl$phone?text=$encodedMessage';
      final uri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        _showError(context, 'Não foi possível abrir o WhatsApp');
        return false;
      }
    } catch (e) {
      _showError(context, 'Erro ao abrir WhatsApp: $e');
      return false;
    }
  }

  /// Exibe mensagem de erro
  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

