import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'cliente.dart';

const String _clienteEnvApiBaseUrl =
    String.fromEnvironment('API_BASE_URL', defaultValue: '');

String _resolveClienteBaseUrl() {
  if (_clienteEnvApiBaseUrl.isNotEmpty) {
    return _clienteEnvApiBaseUrl;
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

class ClienteApi {
  ClienteApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? _resolveClienteBaseUrl();

  final http.Client _client;
  final String _baseUrl;
  static const String _tokenKey = 'access_token';

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<ClienteModel?> findByCpf(String cpf) async {
    final sanitizedCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (sanitizedCpf.length != 11) {
      throw ArgumentError('CPF inválido');
    }

    final uri = Uri.parse('$_baseUrl/clientes/$sanitizedCpf');
    final response = await _client.get(uri, headers: await _headers());

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar cliente: ${response.statusCode} ${response.body}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return ClienteModel.fromJson(decoded);
    }

    throw Exception('Formato inesperado ao buscar cliente');
  }

  Future<ClienteModel> createCliente({
    required String nome,
    required String cpf,
    required String telefone,
  }) async {
    final sanitizedCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (sanitizedCpf.length != 11) {
      throw ArgumentError('CPF inválido');
    }

    final uri = Uri.parse('$_baseUrl/clientes');
    final response = await _client.post(
      uri,
      headers: await _headers(),
      body: jsonEncode({
        'nome': nome,
        'cpf': sanitizedCpf,
        'telefone': telefone,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Erro ao criar cliente: ${response.statusCode} ${response.body}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return ClienteModel.fromJson(decoded);
    }

    throw Exception('Formato inesperado ao criar cliente');
  }
}

