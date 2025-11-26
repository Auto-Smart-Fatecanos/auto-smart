import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../create_orcamento_request.dart';
import '../orcamento_model.dart';
import '../orcamento_item_model.dart';
import 'orcamento_repository.dart';

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

class OrcamentoRepositoryImpl implements OrcamentoRepository {
  OrcamentoRepositoryImpl({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? _resolveDefaultBaseUrl();

  final http.Client _client;
  final String _baseUrl;

  static const String _tokenKey = 'access_token';

  Uri _buildUri(String path, [Map<String, String>? params]) {
    return Uri.parse('$_baseUrl$path').replace(queryParameters: params);
  }

  Future<Map<String, String>> _buildHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<OrcamentoModel>> findAll({int page = 1, int limit = 10}) async {
    final uri = _buildUri(
      '/orcamentos',
      <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    final response = await _client.get(uri, headers: await _buildHeaders());
    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar orçamentos: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      final items = decoded['data'] as List<dynamic>;
      return items
          .map((item) =>
              OrcamentoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (decoded is List) {
      return decoded
          .map((item) =>
              OrcamentoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Formato inesperado da resposta de /orcamentos');
  }

  @override
  Future<List<OrcamentoModel>> findByStatus(
    String status, {
    int page = 1,
    int limit = 10,
  }) async {
    final orcamentos = await findAll(page: page, limit: limit);
    return orcamentos
        .where(
          (orcamento) => orcamento.status.toUpperCase() ==
              status.trim().toUpperCase(),
        )
        .toList();
  }

  @override
  Future<OrcamentoModel> createOrcamento(
    CreateOrcamentoRequest request,
  ) async {
    final uri = _buildUri('/orcamentos');
    final response = await _client.post(
      uri,
      headers: await _buildHeaders(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
        'Erro ao criar orçamento: ${response.statusCode} ${response.body}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return OrcamentoModel.fromJson(decoded);
    }

    throw Exception('Formato inesperado da resposta ao criar orçamento');
  }

  @override
  Future<OrcamentoModel> findOne(int id) async {
    final uri = _buildUri('/orcamentos/$id');
    final response = await _client.get(uri, headers: await _buildHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar orçamento: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return OrcamentoModel.fromJson(decoded);
    }

    throw Exception('Formato inesperado da resposta de /orcamentos/$id');
  }

  @override
  Future<OrcamentoModel> updateStatus(int id, String status) async {
    final uri = _buildUri('/orcamentos/$id/status');
    final response = await _client.patch(
      uri,
      headers: await _buildHeaders(),
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao atualizar status: ${response.statusCode} ${response.body}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return OrcamentoModel.fromJson(decoded);
    }

    throw Exception('Formato inesperado da resposta ao atualizar status');
  }

  @override
  Future<List<OrcamentoItemModel>> updateItens(
    int id,
    List<OrcamentoItemModel> itens,
  ) async {
    final uri = _buildUri('/orcamentos/$id/itens');
    final itensJson = itens.map((item) => {
      'id': item.id,
      'orcamentoId': item.orcamentoId,
      'ativo': item.ativo,
      'descricao': item.descricao,
      'tipoOrcamento': item.tipoOrcamento,
      'orcamentoValor': item.valor,
    }).toList();

    final response = await _client.patch(
      uri,
      headers: await _buildHeaders(),
      body: jsonEncode({'itens': itensJson}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao atualizar itens: ${response.statusCode} ${response.body}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded
          .map((item) =>
              OrcamentoItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Formato inesperado da resposta ao atualizar itens');
  }

  @override
  Future<void> deleteOrcamento(int id) async {
    final uri = _buildUri('/orcamentos/$id');
    final response = await _client.delete(uri, headers: await _buildHeaders());

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Erro ao excluir orçamento: ${response.statusCode} ${response.body}',
      );
    }
  }
}
