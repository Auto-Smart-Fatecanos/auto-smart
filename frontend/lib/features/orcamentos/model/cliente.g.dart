// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClienteModelImpl _$$ClienteModelImplFromJson(Map<String, dynamic> json) =>
    _$ClienteModelImpl(
      id: (json['id'] as num?)?.toInt(),
      nome: json['nome'] as String,
      cpf: json['cpf'] as String,
      telefone: json['telefone'] as String,
    );

Map<String, dynamic> _$$ClienteModelImplToJson(_$ClienteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'cpf': instance.cpf,
      'telefone': instance.telefone,
    };
