import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  static const String _envApiBaseUrl =
      String.fromEnvironment('http://127.0.0.1:3000', defaultValue: '');

  static String get _baseApiUrl {
    if (_envApiBaseUrl.isNotEmpty) {
      return _envApiBaseUrl;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      default:
        return 'http://127.0.0.1:3000';
    }
  }

  static String get _authUrl => '$_baseApiUrl/auth';

  Future<bool> login(String cpf, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_authUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'cpf': cpf,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Tempo de conexão esgotado');
            },
          );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

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
