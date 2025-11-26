import 'package:freezed_annotation/freezed_annotation.dart';

part 'orcamento_item_model.freezed.dart';
part 'orcamento_item_model.g.dart';

@freezed
class OrcamentoItemModel with _$OrcamentoItemModel {
  const factory OrcamentoItemModel({
    int? id,
    @JsonKey(name: 'orcamentoId') int? orcamentoId,
    required String descricao,
    @JsonKey(name: 'tipoOrcamento') required String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') required double valor,
    @Default(true) bool ativo,
  }) = _OrcamentoItemModel;

  factory OrcamentoItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrcamentoItemModelFromJson(json);
}