import 'package:image_picker/image_picker.dart';
import '../orcamento_model.dart';

import '../create_orcamento_request.dart';

import '../orcamento_item_model.dart';

class EarningsData {
  final double totalGanhos;
  final int totalServicos;
  final List<EarningsByMonth> ganhosPorMes;

  EarningsData({
    required this.totalGanhos,
    required this.totalServicos,
    required this.ganhosPorMes,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      totalGanhos: (json['totalGanhos'] as num?)?.toDouble() ?? 0.0,
      totalServicos: (json['totalServicos'] as num?)?.toInt() ?? 0,
      ganhosPorMes: (json['ganhosPorMes'] as List<dynamic>?)
              ?.map((e) => EarningsByMonth.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class EarningsByMonth {
  final int mes;
  final int ano;
  final double total;

  EarningsByMonth({
    required this.mes,
    required this.ano,
    required this.total,
  });

  factory EarningsByMonth.fromJson(Map<String, dynamic> json) {
    return EarningsByMonth(
      mes: (json['mes'] as num?)?.toInt() ?? 0,
      ano: (json['ano'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

abstract interface class OrcamentoRepository {
  Future<List<OrcamentoModel>> findAll({int page = 1, int limit = 10});

  Future<List<OrcamentoModel>> findByStatus(
    String status, {
    int page = 1,
    int limit = 10,
  });

  Future<List<OrcamentoModel>> searchByPlaca(String placa);

  Future<EarningsData> getEarnings();

  Future<OrcamentoModel> createOrcamento(CreateOrcamentoRequest request);

  Future<OrcamentoModel> findOne(int id);

  Future<OrcamentoModel> updateStatus(int id, String status);

  Future<List<OrcamentoItemModel>> updateItens(
    int id,
    List<OrcamentoItemModel> itens,
  );

  Future<void> deleteOrcamento(int id);

  Future<OrcamentoModel> updateFotoVeiculo(int id, XFile foto);
}
