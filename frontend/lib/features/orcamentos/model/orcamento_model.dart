import 'package:freezed_annotation/freezed_annotation.dart';

import 'cliente.dart';
import 'orcamento_item_model.dart';

part 'orcamento_model.freezed.dart';
part 'orcamento_model.g.dart';

@freezed
class OrcamentoModel with _$OrcamentoModel {
  const factory OrcamentoModel({
    int? id,
    @JsonKey(name: 'clienteId') required int clienteId,
    required String placa,
    required String modelo,
    @Default('') String status,
    @JsonKey(name: 'dataCriacao') DateTime? dataCriacao,
    @JsonKey(name: 'orcamentoItems')
    @Default(<OrcamentoItemModel>[])
    List<OrcamentoItemModel> orcamentoItems,
    ClienteModel? cliente,
  }) = _OrcamentoModel;

  factory OrcamentoModel.fromJson(Map<String, dynamic> json) =>
      _$OrcamentoModelFromJson(json);
}