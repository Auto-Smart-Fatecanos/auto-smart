import '../orcamento_model.dart';

import '../create_orcamento_request.dart';

abstract interface class OrcamentoRepository {
  Future<List<OrcamentoModel>> findAll({int page = 1, int limit = 10});

  Future<List<OrcamentoModel>> findByStatus(
    String status, {
    int page = 1,
    int limit = 10,
  });

  Future<OrcamentoModel> createOrcamento(CreateOrcamentoRequest request);
}
