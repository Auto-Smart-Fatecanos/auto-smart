import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use 10.0.2.2 para Android Emulator, localhost para web/desktop
  // Para dispositivo físico, use o IP da sua máquina (ex: http://192.168.1.100:3000)
  static const String baseUrl = 'http://10.0.2.2:3000/auth';
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  Future<bool> login(String cpf, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'cpf': cpf,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Tempo de conexão esgotado');
            },
          );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        // Salvar tokens e dados do usuário
        await prefs.setString(tokenKey, data['access_token']);
        await prefs.setString(refreshTokenKey, data['refresh_token']);
        await prefs.setString(userDataKey, json.encode(data['user']));
        
        print('✅ Login bem-sucedido!');
        return true;
      } else if (response.statusCode == 401) {
        print('❌ Credenciais inválidas');
        return false;
      } else {
        print('❌ Erro do servidor: ${response.statusCode}');
        return false;
      }
    } on SocketException {
      print('❌ Sem conexão com a internet');
      rethrow;
    } on TimeoutException {
      print('❌ Tempo de conexão esgotado');
      rethrow;
    } on FormatException {
      print('❌ Erro ao processar resposta do servidor');
      rethrow;
    } catch (e) {
      print('❌ Erro inesperado: $e');
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar login: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(userDataKey);
      if (userData != null) {
        return json.decode(userData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Erro ao obter dados do usuário: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(tokenKey);
    } catch (e) {
      print('Erro ao obter token: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove(refreshTokenKey);
      await prefs.remove(userDataKey);
      print('✅ Logout realizado com sucesso');
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}
