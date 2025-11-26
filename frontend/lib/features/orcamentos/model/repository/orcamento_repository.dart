import '../orcamento_model.dart';

import '../create_orcamento_request.dart';

import '../orcamento_item_model.dart';

abstract interface class OrcamentoRepository {
  Future<List<OrcamentoModel>> findAll({int page = 1, int limit = 10});

  Future<List<OrcamentoModel>> findByStatus(
    String status, {
    int page = 1,
    int limit = 10,
  });

  Future<OrcamentoModel> createOrcamento(CreateOrcamentoRequest request);

  Future<OrcamentoModel> findOne(int id);

  Future<OrcamentoModel> updateStatus(int id, String status);

  Future<List<OrcamentoItemModel>> updateItens(
    int id,
    List<OrcamentoItemModel> itens,
  );

  Future<void> deleteOrcamento(int id);
}
