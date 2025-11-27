import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _envApiBaseUrl =
    String.fromEnvironment('API_BASE_URL', defaultValue: '');

String _resolveDefaultBaseUrl() {
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

class UserService {
  UserService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? _resolveDefaultBaseUrl();

  final http.Client _client;
  final String _baseUrl;

  static const String _tokenKey = 'access_token';
  static const String _userDataKey = 'user_data';

  Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Obtém os dados do usuário logado do SharedPreferences
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      if (userData != null) {
        return json.decode(userData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao obter dados do usuário: $e');
      return null;
    }
  }

  /// Atualiza os dados do usuário no backend
  Future<void> updateUser({
    required int userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String cpf,
    required int storeId,
    String? password,
  }) async {
    final uri = Uri.parse('$_baseUrl/user/$userId');

    final body = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'cpf': cpf,
      'storeId': storeId,
    };

    // Só inclui password se foi informado
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await _client.put(
      uri,
      headers: await _buildHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception(
        errorBody['message'] ?? 'Erro ao atualizar usuário: ${response.statusCode}',
      );
    }

    // Atualiza os dados no SharedPreferences
    await _updateLocalUserData(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      cpf: cpf,
      storeId: storeId,
    );
  }

  /// Atualiza os dados locais do usuário
  Future<void> _updateLocalUserData({
    required int userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String cpf,
    required int storeId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentData = prefs.getString(_userDataKey);

    Map<String, dynamic> userData = {};
    if (currentData != null) {
      userData = json.decode(currentData) as Map<String, dynamic>;
    }

    // Atualiza os campos
    userData['id'] = userId;
    userData['firstName'] = firstName;
    userData['lastName'] = lastName;
    userData['email'] = email;
    userData['phoneNumber'] = phoneNumber;
    userData['cpf'] = cpf;
    userData['storeId'] = storeId;

    await prefs.setString(_userDataKey, json.encode(userData));
  }
}

