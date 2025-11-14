
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cliente.freezed.dart';
part 'cliente.g.dart';

@freezed
class ClienteModel with _$ClienteModel {
  const factory ClienteModel({
    int? id,
    required String nome,
    required String cpf,
    required String telefone,
  }) = _ClienteModel;

  factory ClienteModel.fromJson(Map<String, dynamic> json) =>
      _$ClienteModelFromJson(json);
}