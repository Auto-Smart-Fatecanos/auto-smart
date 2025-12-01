import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../create_orcamento_request.dart';
import '../orcamento_model.dart';
import '../orcamento_item_model.dart';
import 'orcamento_repository.dart';

export 'orcamento_repository.dart' show EarningsData, EarningsByMonth;

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

  Future<Map<String, String>> _buildHeaders({bool includeContentType = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    return <String, String>{
      if (includeContentType) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
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
    final uri = _buildUri(
      '/orcamentos',
      <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'status': status.trim().toUpperCase(),
      },
    );

    final response = await _client.get(uri, headers: await _buildHeaders());
    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar orçamentos por status: ${response.statusCode} ${response.reasonPhrase}',
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
  Future<EarningsData> getEarnings() async {
    final uri = _buildUri('/orcamentos/ganhos');
    final response = await _client.get(uri, headers: await _buildHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar ganhos: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return EarningsData.fromJson(decoded);
    }

    throw Exception('Formato inesperado da resposta de /orcamentos/ganhos');
  }

  @override
  Future<List<OrcamentoModel>> searchByPlaca(String placa) async {
    final uri = _buildUri('/orcamentos/$placa/veiculo');
    final response = await _client.get(uri, headers: await _buildHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar por placa: ${response.statusCode} ${response.reasonPhrase}',
      );
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded
          .map((item) => OrcamentoModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Formato inesperado da resposta de /orcamentos/:placa/veiculo');
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

  @override
  Future<OrcamentoModel> updateFotoVeiculo(int id, XFile foto) async {
    final uri = _buildUri('/orcamentos/$id/foto');
    final token = await _getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Usuário não autenticado');
    }

    final request = http.MultipartRequest('PATCH', uri);

    request.headers['Authorization'] = 'Bearer $token';

    final bytes = await foto.readAsBytes();
    final multipartFile = http.MultipartFile.fromBytes(
      'foto',
      bytes,
      filename: foto.name.isNotEmpty ? foto.name : 'foto.jpg',
    );
    request.files.add(multipartFile);

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody is Map<String, dynamic>
          ? (errorBody['message'] ?? errorBody['error'] ?? response.body)
          : response.body;
      throw Exception('Erro ao atualizar foto: ${response.statusCode} - $errorMessage');
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return OrcamentoModel.fromJson(decoded);
    }

    throw Exception('Formato inesperado da resposta ao atualizar foto');
  }

  String getOrcamentoPhotoUrl(String nomeFoto) {
    return '$_baseUrl/orcamentos/$nomeFoto/foto';
  }
}
