// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orcamento_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrcamentoItemModelImpl _$$OrcamentoItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrcamentoItemModelImpl(
  id: (json['id'] as num?)?.toInt(),
  orcamentoId: (json['orcamentoId'] as num?)?.toInt(),
  descricao: json['descricao'] as String,
  tipoOrcamento: json['tipoOrcamento'] as String,
  valor: (json['orcamentoValor'] as num).toDouble(),
  ativo: json['ativo'] as bool? ?? true,
);

Map<String, dynamic> _$$OrcamentoItemModelImplToJson(
  _$OrcamentoItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'orcamentoId': instance.orcamentoId,
  'descricao': instance.descricao,
  'tipoOrcamento': instance.tipoOrcamento,
  'orcamentoValor': instance.valor,
  'ativo': instance.ativo,
};
