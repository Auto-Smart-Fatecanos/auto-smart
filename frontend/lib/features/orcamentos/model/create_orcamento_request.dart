import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_orcamento_request.freezed.dart';
part 'create_orcamento_request.g.dart';

@freezed
class CreateOrcamentoItemRequest with _$CreateOrcamentoItemRequest {
  const factory CreateOrcamentoItemRequest({
    required String descricao,
    @JsonKey(name: 'tipoOrcamento') required String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') required double valor,
  }) = _CreateOrcamentoItemRequest;

  factory CreateOrcamentoItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrcamentoItemRequestFromJson(json);
}

@freezed
class CreateOrcamentoRequest with _$CreateOrcamentoRequest {
  const factory CreateOrcamentoRequest({
    @JsonKey(name: 'clienteId') required int clienteId,
    required String placa,
    required String modelo,
    @JsonKey(name: 'orcamentoItens')
    required List<CreateOrcamentoItemRequest> itens,
  }) = _CreateOrcamentoRequest;

  factory CreateOrcamentoRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrcamentoRequestFromJson(json);
}

