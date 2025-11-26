// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orcamento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrcamentoModelImpl _$$OrcamentoModelImplFromJson(Map<String, dynamic> json) =>
    _$OrcamentoModelImpl(
      id: (json['id'] as num?)?.toInt(),
      clienteId: (json['clienteId'] as num).toInt(),
      placa: json['placa'] as String,
      modelo: json['modelo'] as String,
      status: json['status'] as String? ?? '',
      dataCriacao: json['dataCriacao'] == null
          ? null
          : DateTime.parse(json['dataCriacao'] as String),
      orcamentoItems:
          (json['orcamentoItems'] as List<dynamic>?)
              ?.map(
                (e) => OrcamentoItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <OrcamentoItemModel>[],
      cliente: json['cliente'] == null
          ? null
          : ClienteModel.fromJson(json['cliente'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrcamentoModelImplToJson(
  _$OrcamentoModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'clienteId': instance.clienteId,
  'placa': instance.placa,
  'modelo': instance.modelo,
  'status': instance.status,
  'dataCriacao': instance.dataCriacao?.toIso8601String(),
  'orcamentoItems': instance.orcamentoItems,
  'cliente': instance.cliente,
};
