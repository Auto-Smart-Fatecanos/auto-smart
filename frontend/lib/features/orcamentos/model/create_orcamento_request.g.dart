// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_orcamento_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateOrcamentoItemRequestImpl _$$CreateOrcamentoItemRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateOrcamentoItemRequestImpl(
  descricao: json['descricao'] as String,
  tipoOrcamento: json['tipoOrcamento'] as String,
  valor: (json['orcamentoValor'] as num).toDouble(),
);

Map<String, dynamic> _$$CreateOrcamentoItemRequestImplToJson(
  _$CreateOrcamentoItemRequestImpl instance,
) => <String, dynamic>{
  'descricao': instance.descricao,
  'tipoOrcamento': instance.tipoOrcamento,
  'orcamentoValor': instance.valor,
};

_$CreateOrcamentoRequestImpl _$$CreateOrcamentoRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateOrcamentoRequestImpl(
  clienteId: (json['clienteId'] as num).toInt(),
  placa: json['placa'] as String,
  modelo: json['modelo'] as String,
  itens: (json['orcamentoItens'] as List<dynamic>)
      .map(
        (e) => CreateOrcamentoItemRequest.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$$CreateOrcamentoRequestImplToJson(
  _$CreateOrcamentoRequestImpl instance,
) => <String, dynamic>{
  'clienteId': instance.clienteId,
  'placa': instance.placa,
  'modelo': instance.modelo,
  'orcamentoItens': instance.itens,
};
